from prompt_toolkit import HTML
from prompt_toolkit.layout import Window, FormattedTextControl

from director.panel import COLORS, SPACERS, WIDTH


class StationTitle(Window):
    def __init__(self):
        width = WIDTH['station_column']
        self.w = width - 2
        self.fg = COLORS['title']['station_title']['name']['fg']
        self.bg = COLORS['title']['station_title']['name']['bg']
        self.fg_spacer = COLORS['title']['station_title']['spacer']['fg']
        self.bg_spacer = COLORS['title']['station_title']['spacer']['bg']
        self.spacer = SPACERS['station_title']
        super(StationTitle, self).__init__(content=FormattedTextControl(text=self.text()), width=width)

    def set_color(self, fg, bg=None):
        self.fg = fg
        if fg:
            self.bg = bg
        self.set()

    def text(self):
        return HTML(f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>'
                    f'<a fg="{self.fg}" bg="{self.bg}">{"Station":^{self.w}}</a>'
                    f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


class FrequencyTitle(Window):
    def __init__(self, n):
        width = WIDTH['frequency_column']
        self.n, self.w = n, width
        self.fg = COLORS['title']['frequency_title']['name']['fg']
        self.bg = COLORS['title']['frequency_title']['name']['bg']
        self.fg_spacer = COLORS['title']['frequency_title']['spacer']['fg']
        self.bg_spacer = COLORS['title']['frequency_title']['spacer']['bg']
        self.spacer = SPACERS['frequency_title']
        super(FrequencyTitle, self).__init__(content=FormattedTextControl(text=self.text()), width=width)

    def set_color(self, fg, bg=None):
        self.fg = fg
        if fg:
            self.bg = bg
        self.set()

    def text(self):
        f = f"F{self.n}"
        return HTML(f'<a fg="{self.fg}" bg="{self.bg}">{f:^{self.w - 1}}</a>'
                    f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


