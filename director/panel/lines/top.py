from prompt_toolkit import HTML
from prompt_toolkit.layout import Window, FormattedTextControl

from director.panel import COLORS, WIDTH, BOARDERS


class Top(Window):
    def __init__(self):
        self.fg = COLORS['lines']['top']['line']['fg']
        self.bg = COLORS['lines']['top']['line']['bg']
        self.fg_spacer = COLORS['lines']['top']['spacer']['fg']
        self.bg_spacer = COLORS['lines']['top']['spacer']['bg']
        self.line = BOARDERS['top']
        self.left = BOARDERS['top_left']
        self.right = BOARDERS['top_right']
        self.w = WIDTH['panel_column']
        super(Top, self).__init__(content=FormattedTextControl(text=self.text()), height=1)

    def set_color(self, fg, bg=None):
        self.fg = fg
        if bg:
            self.bg = bg
        self.set()

    def text(self):
        return HTML(
            f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.left}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.w - 2)}</a>'
            f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.right}</a>')

    def set(self):
        self.content.text = self.text()
