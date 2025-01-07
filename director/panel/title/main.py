from prompt_toolkit import HTML
from prompt_toolkit.layout import HSplit, Window, FormattedTextControl, VerticalAlign

from director.panel import COLORS, SPACERS, WIDTH


class MainWindow(Window):
    def __init__(self, name, title):
        self.fg = COLORS['title']['main_title'][name]['fg']
        self.bg = COLORS['title']['main_title'][name]['bg']
        self.fg_spacer = COLORS['title']['main_title']['spacer']['fg']
        self.bg_spacer = COLORS['title']['main_title']['spacer']['bg']
        self.spacer = SPACERS['main']
        self.w = WIDTH['panel_column']
        self.title = title
        super(MainWindow, self).__init__(content=FormattedTextControl(text=self.text()))

    def set_color(self, fg, bg=None):
        self.fg = fg
        if bg:
            self.bg = bg
        self.set()

    def text(self):
        return HTML(
            f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>'
            f'<a fg="{self.fg}" bg="{self.bg}">{self.title:^{self.w - 2}}</a>'
            f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


class MainTitle(HSplit):
    def __init__(self, title, subtitle, comment):
        super().__init__([MainWindow('main', title),
                          MainWindow('sub', subtitle),
                          MainWindow('comment', comment)],
                         align=VerticalAlign.TOP, width=WIDTH['panel_column'], height=3)

    def set_background(self, background):
        self.children[0].bg = background
        self.children[1].bg = background
        self.children[2].bg = background
        self.children[0].set()
        self.children[1].set()
        self.children[2].set()
