from threading import Thread
from time import sleep, time
from random import randint

from analyzer.updater import CounterUpdater, TimerUpdater


class Analyzer(Thread):
    def __init__(self, root, executor, log):
        super().__init__(name='Analyzer')
        self.root = root
        self.executor = executor
        self.log = log

        self.calm = 5.0
        # self._counter_max = 5
        # self.run_period = 300
        self.alive_counter = self.alive_counter_prev = 0
        self.err_generate = self.gen_query = 0

        self.timer = TimerUpdater(self.root, self.log)
        self.counter = CounterUpdater(self.root, self.log)
        self.parts = [self.timer, self.counter]
        self.tasks = {
            1: [self.timer, self.counter],
            5: [],
            10: []
        }
        self.execution = {interval: time() + randint(0, interval * 60) for interval in self.tasks}
        self.selector = {key: part for part in self.parts for key in part.category}

    # @property
    # def calm(self):
    #     return self._calm
    #
    # @calm.setter
    # def calm(self, p):
    #     self._calm = p
    #     self._counter_max = int(self.run_period / p)

    def add(self, category, items):
        self.selector[category].add(items)

    def status(self):
        stat = self.alive_counter != self.alive_counter_prev
        self.alive_counter_prev = self.alive_counter
        return stat

    # def sleep(self):
    #     counter = self._counter_max
    #     while self.root.keep_alive and counter > 0:
    #         sleep(self.calm)
    #         if not self.root.keep_alive:
    #             break
    #         counter -= 1

    def run(self):
        self.log.info('Started')
        while self.root.keep_alive:
            try:
                self.generate()
            except Exception as e:
                self.err_generate += 1
                self.log.exception(f'Error on Query Generation! {e}')

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
                    except Exception as e:
                        self.err_generate += 1
                        self.log.exception(f'Error on Generate Queries or extending query list! {e}')
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
