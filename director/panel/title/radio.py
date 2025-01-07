from prompt_toolkit import HTML
from prompt_toolkit.layout import Window, FormattedTextControl, VSplit, HorizontalAlign

from director.panel import WIDTH, COLORS, SPACERS


class FreeTitle(Window):
    def __init__(self, station_title):
        width = WIDTH['station_column']
        self.w = width - 2
        if COLORS['free_same_as_station']:
            self.fg = COLORS['title']['station_title']['name']['fg']
            self.bg = COLORS['title']['station_title']['name']['bg']
        else:
            self.fg = COLORS['title']['free_title']['name']['fg']
            self.bg = COLORS['title']['free_title']['name']['bg']
        self.fg_spacer = COLORS['title']['free_title']['spacer']['fg']
        self.bg_spacer = COLORS['title']['free_title']['spacer']['bg']
        self.same_as_title = COLORS['same_bg_column']
        if self.same_as_title and COLORS['bg_station_column']:
            self.col_bg = station_title.bg

        self.spacer = SPACERS['free_title']
        super(FreeTitle, self).__init__(content=FormattedTextControl(text=self.text()), width=width)

    def set_color(self, fg, bg=None):
        self.fg = fg
        if fg:
            self.bg = bg
        self.set()

    def text(self):
        if self.same_as_title:
            return HTML(f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>'
                        f'<a fg="{self.fg}" bg="{self.col_bg}">{" ":^{self.w}}</a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')
        else:
            return HTML(f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>'
                        f'<a fg="{self.fg}" bg="{self.bg}">{" ":^{self.w}}</a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


class RadioTitle(Window):
    def __init__(self, name, last=False):
        self.fg = COLORS['title']['radio_title'][name]['fg']
        self.bg = COLORS['title']['radio_title'][name]['bg']
        self.fg_spacer = COLORS['title']['radio_title']['spacer']['fg']
        self.bg_spacer = COLORS['title']['radio_title']['spacer']['bg']
        self.spacer = SPACERS['radio']['last'] if last else SPACERS['radio']['inside']
        self.w = WIDTH['radio_column']
        self.name = name.upper()
        super(RadioTitle, self).__init__(content=FormattedTextControl(text=self.text()))

    def set_color(self, fg, bg=None):
        self.fg = fg
        if bg:
            self.bg = bg
        self.set()

    def text(self):
        return HTML(f'<a fg="{self.fg}" bg="{self.bg}">{self.name:^{self.w - 1}}</a>'
                    f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


class RadioGroupTitle(VSplit):
    def __init__(self):
        self.panel = {'TXM': RadioTitle('txm'),
                      'TXS': RadioTitle('txs'),
                      'RXM': RadioTitle('rxm'),
                      'RXS': RadioTitle('rxs', last=True)}
        super().__init__([self.panel['TXM'], self.panel['TXS'], self.panel['RXM'], self.panel['RXS']],
                         align=HorizontalAlign.LEFT, width=WIDTH['frequency_column'])

    def set_radio_title_color(self, radio, fg, bg=None):
        self.panel[radio].set_color(fg, bg)
