from threading import Thread
from time import sleep, time
from random import randint

from analyzer.reception import Reception
from analyzer.transmission import Transmission
from analyzer.updater import CounterUpdater, TimerUpdater


class Analyzer(Thread):
    def __init__(self, radio, executor, log):
        super().__init__(name='Analyzer')
        self.radio = radio
        self.health = self.radio.health
        self.executor = executor
        self.log = log
        self.dispatcher = self.radio.dispatcher

        self.calm = 5.0
        self.alive_counter = self.alive_counter_prev = 0
        self.err_generate = self.gen_query = 0

        self.timer = TimerUpdater(self.radio, self.radio.queries, self.log)
        self.counter = CounterUpdater(self.radio, self.radio.queries, self.log)
        self.parts = [self.timer, self.counter]
        self.tasks = {
            1: [self.timer, ],
            5: [self.counter, ],
            10: []
        }
        if self.radio.radio.type == 'TX':
            self.transmission = Transmission(self, self.radio.radio, self.radio.queries, self.log)
            self.tasks[3] = [self.transmission, ]
            self.parts.append(self.transmission)
        else:
            self.reception = Reception(self, self.radio.radio, self.radio.queries, self.log)
            self.tasks[3] = [self.reception, ]
            self.parts.append(self.reception)

        self.execution = {interval: time() + randint(0, interval * 60) for interval in self.tasks}
        self.execution[3] += 90
        self.selector = {key: part for part in self.parts for key in part.category}
        self.keys = self.transmission.category if self.radio.radio.type == 'TX' else self.reception.category

    def add(self, category, items):
        self.selector[category].add(category, items)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    def run(self):
        self.log.info('Started')
        while self.radio.keep_alive:
            try:
                self.generate()
            except Exception as e:
                self.err_generate += 1
                self.log.exception(f'Error on Query Generation! {e}')
                self.dispatcher.register_message(self.__class__.__name__, e.__class__.__name__, e.args)

            self.alive_counter += 1
            sleep(self.calm)

        self.log.info('Finished')

    def generate(self):
        for interval, tasks in self.tasks.items():
            if time() >= self.execution[interval]:
                self.log.debug(f'Generating Query for {tasks} Interval={interval}')
                for task in tasks:
                    try:
                        query_list = task.generate()
                    except KeyError as e:
                        self.err_generate += 1
                        self.log.exception(f'Task Error: {e}')
                        self.dispatcher.register_message(self.__class__.__name__, e.__class__.__name__, e.args)
                    except Exception as e:
                        self.err_generate += 1
                        self.log.exception(f'Error on Generate Queries or extending query list! {e}')
                        self.dispatcher.register_message(self.__class__.__name__, e.__class__.__name__, e.args)
                    else:
                        self.log.debug(f'{task.category}: {query_list}')
                        self.gen_query += len(query_list)
                        for statement in query_list:
                            if statement:
                                self.executor.add(statement)
                    finally:
                        self.alive_counter += 1
                self.execution[interval] += interval * 60

            sleep(self.calm)

        # if self.radio.radio.type == 'TX':
        #     try:
        #         query_list = self.transmission.execute()
        #         if query_list:
        #             for statement in query_list:
        #                 if statement:
        #                     self.executor.add(statement)
        #     except Exception as e:
        #         self.err_generate += 1
        #         self.log.exception(f'Error on Generate Transmission Queries or extending query list! {e}')
        # else:
        # if self.radio.radio.type == 'RX':
        #     self.reception.execute()
        sleep(self.calm)
