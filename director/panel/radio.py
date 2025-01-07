from prompt_toolkit.formatted_text import HTML
from prompt_toolkit.layout import Window
from prompt_toolkit.layout.controls import FormattedTextControl
from prompt_toolkit.application import get_app

from director.panel import COLORS, SPACERS, LED


class Radio(Window):
    def __init__(self, frequency_title, radio_title, last=False):
        self.left = COLORS['radio']['led']['default_left']
        self.right = COLORS['radio']['led']['default_right']
        self.bg = COLORS['background']
        self.fg_spacer = COLORS['radio']['spacer']['fg']
        self.bg_spacer = COLORS['radio']['spacer']['bg']
        self.spacer = SPACERS['radio']['last'] if last else SPACERS['radio']['inside']
        self.same_as_title = COLORS['same_bg_column']
        if self.same_as_title:
            self.col_bg = radio_title.bg if COLORS['bg_column_deep'] else frequency_title.bg
        super(Radio, self).__init__(content=FormattedTextControl(text=self.text()))

    def set_color(self, left, right, background=None):
        bg = self.col_bg if self.same_as_title else self.bg
        self.left, self.right = LED['left'].get(left, bg), LED['right'].get(right, bg)
        if background:
            self.bg = background
        self.set()
        get_app().invalidate()  # Refresh the UI

    def text(self):
        if self.same_as_title:
            return HTML(f'<a fg="{self.bg}" bg="{self.col_bg}"> </a>'
                        f'<a fg="{self.left}" bg="{self.left}">  </a>'
                        f'<a fg="{self.bg}" bg="{self.col_bg}"> </a>'
                        f'<a fg="{self.right}" bg="{self.right}">  </a>'
                        f'<a fg="{self.bg}" bg="{self.col_bg}"> </a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')
        else:
            return HTML(f'<a fg="{self.bg}" bg="{self.bg}"> </a>'
                        f'<a fg="{self.left}" bg="{self.left}">  </a>'
                        f'<a fg="{self.bg}" bg="{self.bg}"> </a>'
                        f'<a fg="{self.right}" bg="{self.right}">  </a>'
                        f'<a fg="{self.bg}" bg="{self.bg}"> </a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


class NoRadio(Window):
    def __init__(self, frequency_title, radio_title, last=False):
        self.bg = COLORS['background']
        self.fg_spacer = COLORS['radio']['spacer']['fg']
        self.bg_spacer = COLORS['radio']['spacer']['bg']
        self.spacer = SPACERS['radio']['last'] if last else SPACERS['radio']['inside']
        self.same_as_title = COLORS['same_bg_column']
        if self.same_as_title:
            self.col_bg = radio_title.bg if COLORS['bg_column_deep'] else frequency_title.bg
        super(NoRadio, self).__init__(content=FormattedTextControl(text=self.text()))

    def set_color(self, background):
        self.bg = background
        self.set()

    def text(self):
        if self.same_as_title:
            return HTML(f'<a fg="{self.bg}" bg="{self.col_bg}">       </a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')
        else:
            return HTML(f'<a fg="{self.bg}" bg="{self.bg}">       </a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()
