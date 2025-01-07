from threading import Thread
from time import sleep

from prompt_toolkit import Application
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.output import ColorDepth
from prompt_toolkit.styles import Style

from director.panel.panel import Panel


class PanelController(Thread):
    def __init__(self, stations, log):
        super().__init__(name='PanelController')
        self.stations = stations
        self.log = log
        self.panel = Panel(self.stations)
        self.kb = KeyBindings()
        self.bind_keys()

        style = Style.from_dict({'background': 'bg:#1c1a27', })
        self.app = Application(layout=self.panel, key_bindings=self.kb, full_screen=True,
                          color_depth=ColorDepth.DEPTH_24_BIT, style=style)
        self.stop_command = None
        self.manager_closed = False

    def manager_is_closed(self):
        self.manager_closed = True

    def set_stop_command(self, command):
        self.stop_command = command

    def run(self):
        self.app.run()

    def bind_keys(self):
        @self.kb.add('q')
        def _exit(event):
            self.log.debug(f'{self.__class__.__name__}: Exit Command Received')
            self.stop_command()
            while not self.manager_closed:
                sleep(1)
            self.log.debug(f'{self.__class__.__name__}: self.manager_closed = {self.manager_closed}')

            event.app.exit()

