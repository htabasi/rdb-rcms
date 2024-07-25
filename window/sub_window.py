import unicurses as uc
from .color import Colors
from .presenter import Row, RowPresenter
from .progress import ProgressGenerator
from .hotkey import HotKey
from threading import Thread
from time import sleep


class SubWindow:
    def __init__(self, height, width, starty, startx, title, color: Colors):
        self.window = uc.newwin(height, width, starty, startx)
        self.width = width
        self.color = color
        uc.box(self.window, 0, 0)
        uc.wborder(self.window)
        # self.print_at(1, 1, title, self.color.bg)
        self.refresh()

    def set_bg(self):
        uc.wbkgd(self.window, self.color.bg)

    def refresh(self):
        uc.wrefresh(self.window)
        uc.refresh()

    def print_at(self, y, x, text, c):
        uc.wattron(self.window, self.color.color(c))
        uc.mvwaddstr(self.window, y, x, text)
        uc.wattroff(self.window, self.color.color(c))

    def print_in_middle(self, string, c=0):
        c = self.color.bg if c == 0 else c
        y, x = uc.getyx(self.window)
        x = (uc.getmaxx(self.window) - len(string)) // 2

        self.print_at(y, x, string, c)
        self.refresh()


class StatusWindow(SubWindow):
    def __init__(self, height, width, starty, startx, title, color: Colors):
        super().__init__(height, width, starty, startx, title, color)
        self.progress = ProgressGenerator()
        self.rotator, self.rotator_color, self.rotator_pos = None, None, None
        self.deterministic_progress = True

    def config_status_progress(self, task, count):
        parts = [25, 12, 20, 7]
        self.progress.config(task, count, parts, partial=True)
        self.deterministic_progress = True

    def set_status_progress(self, current, index):
        parts = self.progress.get_bar(current, index)
        pos = [1,
               self.progress.task_len,
               self.progress.task_len + self.progress.current_len + 1,
               self.progress.task_len + self.progress.current_len + len(parts[2]) + 1,
               self.progress.task_len + self.progress.current_len + self.progress.progress_len + 1]
        self.print_at(1, pos[0], parts[0], 22)
        self.print_at(1, pos[1], parts[1], 15)
        self.print_at(1, pos[2], parts[2], 36)
        self.print_at(1, pos[3], parts[3], 43)
        self.print_at(1, pos[4], parts[4], 15)
        self.refresh()

    def config_evaluating_status(self, task):
        from itertools import cycle
        self.rotator_pos = self.width - 4
        self.print_at(1, 1, f"{task:<{self.width - 4}}", 22)
        self.rotator = cycle([f"{chr(9600)} ", f" {chr(9600)}", f" {chr(9604)}", f"{chr(9604)} "])
        self.rotator_color = cycle([15, 22, 36])
        self.deterministic_progress = False

    def set_evaluating_status(self, *args):
        if args is not None:
            self.print_at(1, 50, args[0], 15)
        self.print_at(1, self.rotator_pos, next(self.rotator), next(self.rotator_color))
        self.refresh()

    def set_progress(self, *args):
        if self.deterministic_progress:
            self.set_status_progress(*args)
        else:
            self.set_evaluating_status(*args)

    def set_bg(self):
        uc.wbkgd(self.window, self.color.status_bg)


class HotKeyWindow(SubWindow):
    hotkeys = [HotKey('F1', 'All Messages'),
               HotKey('F2', 'Connection Messages'),
               HotKey('F3', 'Alive Messages'),
               HotKey('Up', 'Scroll Up'),
               HotKey('Down', 'Scroll Down'),
               HotKey('Q', 'Exit')]

    def set_bg(self):
        uc.wbkgd(self.window, self.color.hotkey_bg)

    def draw(self):
        parts = (self.width - 2) // len(self.hotkeys)
        for i, hk in enumerate(self.hotkeys):
            self.print_at(1, 1 + i * parts, hk.key, hk.key_color)
            self.print_at(1, 2 + i * parts + len(hk.key), hk.action, hk.action_color)

        self.refresh()


class TableWindow(SubWindow):
    temp_thread: Thread

    def __init__(self, height, width, starty, startx, title, color: Colors, parent):
        super().__init__(height, width, starty, startx, title, color)
        self.parent = parent
        self.view_len = height - 2
        self.row_len = width - 4
        self.buffer, self.alive_buffer, self.connection_buffer = [], [], []
        self.max_buffer = 1000
        self.start_view, self.end_view = 0, 0
        self.alive_start_view, self.alive_end_view = 0, 0
        self.connection_start_view, self.connection_end_view = 0, 0
        self.row_presenter = RowPresenter(self.window, color, self.row_len)
        self.view_temporary = False
        self.temp_start_view, self.temp_end_view = 0, 0
        self.temp_view_max_period, self.temp_counter = 30, 0
        self.temp_thread_defined = False
        self.showing_category = 'Overall'

    def set_bg(self):
        uc.wbkgd(self.window, self.color.table_bg)

    def add(self, row: Row):
        self.start_view, self.end_view = self.step_forward(row, self.buffer, self.start_view, self.end_view)
        if row.category == 'Alive':
            self.alive_start_view, self.alive_end_view = self.step_forward(row, self.alive_buffer,
                                                                           self.alive_start_view, self.alive_end_view)
        if row.category == 'Connection':
            self.connection_start_view, self.connection_end_view = self.step_forward(row, self.connection_buffer,
                                                                                     self.connection_start_view,
                                                                                     self.connection_end_view)

    def step_forward(self, row, buffer, start, end):
        if len(buffer) >= self.max_buffer:
            buffer.pop(0)
            start -= 1
            end -= 1
        buffer.append(row)

        if end - start == self.view_len:
            start += 1
        end += 1
        return start, end

    def get_view_buffer(self):
        # print(self.start_view, self.end_view)
        if self.showing_category == 'Alive':
            if self.view_temporary:
                return self.alive_buffer[self.temp_start_view:self.temp_end_view].copy()
            else:
                return self.alive_buffer[self.alive_start_view:self.alive_end_view].copy()
        elif self.showing_category == 'Connection':
            if self.view_temporary:
                return self.connection_buffer[self.temp_start_view:self.temp_end_view].copy()
            else:
                return self.connection_buffer[self.connection_start_view:self.connection_end_view].copy()
        else:
            if self.view_temporary:
                return self.buffer[self.temp_start_view:self.temp_end_view].copy()
            else:
                return self.buffer[self.start_view:self.end_view].copy()

    def load_buffer(self):
        buffer = self.get_view_buffer()
        for i, row in enumerate(buffer):
            self.row_presenter.put(i + 1, row)
        if len(buffer) < self.view_len:
            for i in range(len(buffer), self.view_len):
                self.row_presenter.put_free(i + 1)
        self.refresh()

    def scroll_up_down(self, direction):
        if not self.view_temporary:
            if self.showing_category == 'Alive':
                self.temp_start_view = self.alive_start_view
                self.temp_end_view = self.alive_end_view
            elif self.showing_category == 'Connection':
                self.temp_start_view = self.connection_start_view
                self.temp_end_view = self.connection_end_view
            else:
                self.temp_start_view = self.start_view
                self.temp_end_view = self.end_view
        self.check_temp_thread_stat()
        self.set_max_temp()

        if direction == 'UP':
            if self.temp_start_view > 0:
                self.temp_start_view -= 1
                self.temp_end_view -= 1
        else:
            if self.showing_category == 'Alive':
                buffer = self.alive_buffer
            elif self.showing_category == 'Connection':
                buffer = self.connection_buffer
            else:
                buffer = self.buffer

            if self.temp_end_view < len(buffer):
                self.temp_start_view += 1
                self.temp_end_view += 1

    def show_category(self, category):
        self.showing_category = category
        self.stop_temp_view()

    def check_temp_thread_stat(self):
        if not (self.temp_thread_defined and self.temp_thread.is_alive()):
            if not self.temp_thread_defined:
                self.temp_thread = Thread(target=self.start_temp_view, name='Temp Scroll Controller', daemon=True)
                self.temp_thread_defined = True
            self.temp_thread.start()

    def set_max_temp(self):
        self.temp_counter = self.temp_view_max_period
        self.view_temporary = True

    def start_temp_view(self):
        self.view_temporary = True
        while self.temp_counter:
            # self.parent.write_temp(f"{self.temp_counter:^3} s  {self.view_temporary}")
            sleep(1)
            self.temp_counter -= 1

        self.view_temporary = False
        self.temp_thread_defined = False

    def stop_temp_view(self):
        self.temp_counter = 0
        self.view_temporary = False
        self.temp_thread_defined = False


class ViewWindow(SubWindow):
    def __init__(self, height, width, starty, startx, title, color: Colors, parent):
        super().__init__(height, width, starty, startx, title, color)
        self.parent = parent
        self.view_len = height - 2
        self.row_len = width - 4
