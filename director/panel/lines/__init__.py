from prompt_toolkit import HTML
from prompt_toolkit.layout import Window, FormattedTextControl, VSplit

from director.panel import COLORS, WIDTH, BOARDERS


class RadioBorder(Window):
    def __init__(self, part, last=False, border=False, frequency_title=None, radio_title=None, *args, **kwargs):
        self.fg = COLORS['lines'][part]['line']['fg']
        self.bg = COLORS['lines'][part]['line']['bg']
        self.fg_spacer = COLORS['lines'][part]['spacer']['fg']
        self.bg_spacer = COLORS['lines'][part]['spacer']['bg']
        self.line = self.get_line()
        self.spacer = self.get_spacer(last, border)
        self.w = self.get_width()
        self.same_as_title = COLORS['same_bg_column'] and frequency_title is not None
        if self.same_as_title:
            self.col_bg = radio_title.bg if COLORS['bg_column_deep'] else frequency_title.bg

        super().__init__(content=FormattedTextControl(text=self.text()), height=1, *args, **kwargs)

    def get_width(self):
        return WIDTH['radio_column']

    def get_line(self):
        return BOARDERS['horizontal_dual']

    def get_spacer(self, last, border):
        if border and last:
            return BOARDERS['bottom_right']
        elif last:
            return BOARDERS['bottom_dual']
        else:
            return BOARDERS['bottom_single']

    def set_color(self, left, right, background=None):
        self.left, self.right = left, right
        if background:
            self.bg = background
        self.set()

    def text(self):
        if self.same_as_title:
            return HTML(f'<a fg="{self.fg}" bg="{self.col_bg}">{self.line * (self.w - 1)}</a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')
        else:
            return HTML(f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.w - 1)}</a>'
                        f'<a fg="{self.fg_spacer}" bg="{self.bg_spacer}">{self.spacer}</a>')

    def set(self):
        self.content.text = self.text()


class FrequencyBorder(VSplit):
    def __init__(self, part, border=False, frequency_title=None, radio_group=None, *args, **kwargs):
        self.bg = COLORS['background']
        if frequency_title is None:
            lines = [part(), part(), part(),part(last=True, border=border)]
        else:
            lines = [part(frequency_title=frequency_title, radio_title=radio_group.panel['TXM']),
                     part(frequency_title=frequency_title, radio_title=radio_group.panel['TXS']),
                     part(frequency_title=frequency_title, radio_title=radio_group.panel['RXM']),
                     part(frequency_title=frequency_title, radio_title=radio_group.panel['RXS'], last=True, border=border)]
        super(FrequencyBorder, self).__init__(lines, height=1, width=WIDTH['frequency_column'], *args, **kwargs)


class StationBorder(Window):
    def __init__(self, part, station_title=None, *args, **kwargs):
        self.fg = COLORS['lines'][part]['line']['fg']
        self.bg = COLORS['lines'][part]['line']['bg']
        self.left_spacer_fg = COLORS['lines'][part]['border']['fg']
        self.left_spacer_bg = COLORS['lines'][part]['border']['bg']
        self.right_spacer_fg = COLORS['lines'][part]['spacer']['fg']
        self.right_spacer_bg = COLORS['lines'][part]['spacer']['bg']
        self.line = BOARDERS[{'inside': 'horizontal_single'}.get(part, 'horizontal_dual')]
        self.left_spacer = BOARDERS[{'third': 'left_dual', 'inside': 'left_single', 'bottom': 'bottom_left'}.get(part)]

        self.right_spacer = BOARDERS[{'third': 'cross_dual_dual',
                                      'inside': 'cross_single_dual',
                                      'bottom': 'bottom_dual'}.get(part)]
        self.same_as_title = COLORS['same_bg_column'] if station_title is not None else False
        if self.same_as_title and COLORS['bg_station_column']:
            self.col_bg = station_title.bg

        self.w = WIDTH['station_column']
        super(StationBorder, self).__init__(content=FormattedTextControl(text=self.text()),
                                            height=1, width=self.w, *args, **kwargs)

    def set_color(self, left, right, background=None):
        self.left, self.right = left, right
        if background:
            self.bg = background
        self.set()

    def text(self):
        if self.same_as_title:
            return HTML(f'<a fg="{self.left_spacer_fg}" bg="{self.left_spacer_bg}">{self.left_spacer}</a>'
                        f'<a fg="{self.fg}" bg="{self.col_bg}">{self.line * (self.w - 2)}</a>'
                        f'<a fg="{self.right_spacer_fg}" bg="{self.right_spacer_bg}">{self.right_spacer}</a>')
        else:
            return HTML(f'<a fg="{self.left_spacer_fg}" bg="{self.left_spacer_bg}">{self.left_spacer}</a>'
                        f'<a fg="{self.fg}" bg="{self.bg}">{self.line * (self.w - 2)}</a>'
                        f'<a fg="{self.right_spacer_fg}" bg="{self.right_spacer_bg}">{self.right_spacer}</a>')

    def set(self):
        self.content.text = self.text()


class Line(VSplit):
    def __init__(self, station_part, frequency_part, frequency_children=None, radio_children=None, *args, **kwargs):
        if frequency_children is None:
            parts = [station_part(), frequency_part(), frequency_part(), frequency_part(border=True)]
        else:
            parts = [station_part(station_title=frequency_children[0]),
                     frequency_part(frequency_title=frequency_children[1], radio_group=radio_children[1]),
                     frequency_part(frequency_title=frequency_children[2], radio_group=radio_children[2]),
                     frequency_part(frequency_title=frequency_children[3], radio_group=radio_children[3], border=True)]
        super(Line, self).__init__(parts, height=1, *args, **kwargs)
