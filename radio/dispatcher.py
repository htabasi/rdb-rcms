from threading import Thread
from multiprocessing import Pipe
from time import sleep
from datetime import datetime, UTC


class Dispatcher(Thread):
    def __init__(self, parent, name, downward_portal_receiver: Pipe, upward_portal_sender: Pipe):
        super(Dispatcher, self).__init__(name='Dispatcher', daemon=False)
        if downward_portal_receiver is None:
            self.single_mode = True
        else:
            self.single_mode = False
            self.calm = 1
            self.parent = parent
            self.radio = name
            self.station = name[:3]
            self.receiver = downward_portal_receiver
            self.sender = upward_portal_sender
            self.keep_alive = True
            self.message_index = 0
            self.messages = []
            self.status = []
        self.log = None
        self.log_ok = False

    def set_log(self, log):
        self.log = log
        self.log_ok = True

    def run(self):
        if self.single_mode:
            return

        while self.keep_alive:
            sleep(self.calm)
            while self.receiver.poll():
                command = self.receiver.recv()

                if command == 'restart':
                    self.parent.close(restart=True)
                elif command == 'exit':
                    self.parent.close()
                    self.sender.send({'radio': self.radio,
                                'station': self.station,
                                'date': datetime.now(UTC),
                                'category': 'Status',
                                'alive': False,
                                'connection': False,
                                'database': False})
                    break

            try:
                if self.log_ok:
                    self.log.debug(f'{self.__class__.__name__}: Status length: {len(self.status)}')

                while self.status:
                    new_status = self.status.pop(0)
                    if self.log_ok:
                        self.log.debug(f'{self.__class__.__name__}: New Status: {new_status}')
                    self.sender.send(new_status)
            except Exception as e:
                self.register_message(self.__class__.__name__, e.__class__.__name__, e.args)

            try:
                if self.log_ok:
                    self.log.debug(f'{self.__class__.__name__}: Messages length: {len(self.messages)}')
                while self.messages:
                    new_message = self.messages.pop(0)
                    if self.log_ok:
                        self.log.debug(f'{self.__class__.__name__}: New Message: {new_message}')
                    self.sender.send(new_message)
            except Exception as e:
                self.register_message(self.__class__.__name__, e.__class__.__name__, e.args)

    def register_message(self, category, exception, e_args):
        if not self.single_mode:
            date = datetime.now(UTC)
            self.message_index += 1
            if self.log_ok:
                self.log.debug(f'{self.__class__.__name__}: register new message {category} {exception} {e_args}')
            self.messages.append({'index': self.message_index,
                                  'radio': self.radio,
                                  'station': self.station,
                                  'date': date,
                                  'category': category,
                                  'exception': exception,
                                  'e_args': e_args})

    def update_status(self, date, alive=None, connection=None, database=None):
        if not self.single_mode:
            if self.log_ok:
                self.log.debug(f'{self.__class__.__name__}: Updating Status alive={alive}, connection={connection}, database={database}')
            self.status.append({'radio': self.radio,
                                'station': self.station,
                                'date': date,
                                'category': 'Status',
                                'alive': alive,
                                'connection': connection,
                                'database': database})

    def set_alive(self, stat):
        if not self.single_mode:
            self.update_status(datetime.now(UTC), alive=stat)

    def set_connect(self):
        if not self.single_mode:
            self.update_status(datetime.now(UTC), connection=True)

    def set_disconnect(self):
        if not self.single_mode:
            self.update_status(datetime.now(UTC), connection=False)

    def set_db_connect(self, stat):
        if not self.single_mode:
            self.update_status(datetime.now(UTC), database=stat)

    def close(self):
        self.keep_alive = False