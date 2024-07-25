import unicurses as uc
from threading import Thread
from time import sleep
from . import *
from .presenter import Row


class HotKeyController(Thread):
    def __init__(self, parent, running, termination_func):
        super().__init__(name='HotKey Controller Thread')
        self.running = running
        self.parent = parent
        self.termination_func = termination_func

    def run(self):
        sleep(1)
        closed = False
        while self.running[0] and not closed:
            ch = uc.getch()
            if ch == uc.KEY_UP:
                self.parent.table.scroll_up_down('UP')
            elif ch == uc.KEY_DOWN:
                self.parent.table.scroll_up_down('DOWN')
            elif ch == uc.KEY_LEFT:
                print('LEFT KEY')
            elif ch == uc.KEY_RIGHT:
                print('RIGHT KEY')
            elif ch == uc.KEY_F(1):
                self.parent.table.show_category('Overall')
            elif ch == uc.KEY_F(2):
                self.parent.table.show_category('Connection')
            elif ch == uc.KEY_F(3):
                self.parent.table.show_category('Alive')
            elif ch == uc.KEY_HOME:
                self.parent.table.refresh()
                self.parent.refresh()

            elif ch in {ord('q'), ord('Q')}:
                self.parent.add_message(Row(INFO, 'HotKey', 'HotKey Controller', 'Exit Command Received'))
                self.parent.table.stop_temp_view()
                sleep(0.2)
                self.termination_func()
                closed = True
