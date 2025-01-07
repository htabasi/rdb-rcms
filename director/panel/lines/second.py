from prompt_toolkit import HTML
from prompt_toolkit.layout import Window, FormattedTextControl

from director.panel import COLORS, WIDTH, BOARDERS


class Second(Window):
    def __init__(self):
        self.fg = COLORS['lines']['second']['line']['fg']
        self.bg = COLORS['lines']['second']['line']['bg']
        self.fg_spacer = COLORS['lines']['second']['spacer']['fg']
        self.bg_spacer = COLORS['lines']['second']['spacer']['bg']
        self.left = BOARDERS['left_dual']
        self.right = BOARDERS['right_dual']
        self.line = BOARDERS['horizontal_dual']
        self.inside = BOARDERS['top_dual']
        self.station_width = WIDTH['station_column']
        self.frequency_width = WIDTH['frequency_column']
        super(Second, self).__init__(content=FormattedTextControl(text=self.text()), height=1)

    def set_color(self, fg, bg=None):
        self.fg = fg
        if bg:
            self.bg = bg
        self.set()

    def text(self):
        return HTML(
            f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.left}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.station_width - 2)}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.inside}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.frequency_width - 1)}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.inside}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.frequency_width - 1)}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.inside}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.frequency_width - 1)}</a>'
            f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.right}</a>')

    def set(self):
        self.content.text = self.text()
