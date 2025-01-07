from prompt_toolkit.layout.containers import VSplit, HorizontalAlign, Window
from prompt_toolkit.layout import FormattedTextControl
from prompt_toolkit import HTML

from director.panel.frequency import Frequency, NoFrequency
from director.panel import COLORS, SPACERS, WIDTH


class StationName(VSplit):
    def __init__(self, code, name, station_title):
        self.code, self.name = code, name
        self.spacer = SPACERS['station_name']
        self.colors = COLORS['station_name']
        self.same_as_title = COLORS['same_bg_column']
        if COLORS['bg_station_column'] and self.same_as_title:
            self.col_bg = station_title.bg
        self.window = Window(content=FormattedTextControl(text=self.text()))
        super(StationName, self).__init__([self.window], width=WIDTH['station_column'], height=1)

    def set_color(self, key, fg, bg=None):
        if key in self.colors:
            self.colors[key]['fg'] = fg
            if bg:
                self.colors[key]['bg'] = bg
        self.set()

    def text(self):
        if self.same_as_title:
            return HTML(f"<a fg='{self.colors['spacer']['fg']}' bg='{self.col_bg}'>{self.spacer} </a>"
                        f"<a fg='{self.colors['code']['fg']}' bg='{self.col_bg}'>{self.code:>3}</a>"
                        f"<a fg='{self.colors['dot']['fg']}' bg='{self.col_bg}'>.</a>"
                        f"<a fg='{self.colors['name']['fg']}' bg='{self.col_bg}'>{self.name:3} </a>"
                        f"<a fg='{self.colors['spacer']['fg']}' bg='{self.col_bg}'> {self.spacer}</a>")
        else:
            return HTML(f"<a fg='{self.colors['spacer']['fg']}' bg='{self.colors['spacer']['bg']}'>{self.spacer} </a>"
                        f"<a fg='{self.colors['code']['fg']}' bg='{self.colors['code']['bg']}'>{self.code:>3}</a>"
                        f"<a fg='{self.colors['dot']['fg']}' bg='{self.colors['dot']['bg']}'>.</a>"
                        f"<a fg='{self.colors['name']['fg']}' bg='{self.colors['name']['bg']}'>{self.name:3} </a>"
                        f"<a fg='{self.colors['spacer']['fg']}' bg='{self.colors['spacer']['bg']}'> {self.spacer}</a>")

    def set(self):
        self.window.content.text = self.text()


class Station(VSplit):
    def __init__(self, code, name, frequency_title, radio_title, fc=3):
        self.panel = ([StationName(code, name, frequency_title.children[0])] +
                      [Frequency(frequency_title.children[f + 1], radio_title.children[f + 1]) for f in range(fc)])
        if fc < 3:
            self.panel += [NoFrequency(frequency_title.children[fc + f + 1],
                                       radio_title.children[fc + f + 1]) for f in range(3 - fc)]
        super().__init__(self.panel, align=HorizontalAlign.LEFT, width=fc * 34 + 12, height=1)
