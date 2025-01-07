from director.panel import BOARDERS
from director.panel.lines import RadioBorder, FrequencyBorder, StationBorder, Line


class RadioBorderBottom(RadioBorder):
    def __init__(self, frequency_title=None, radio_title=None, *args, **kwargs):
        super().__init__(part='bottom', frequency_title=frequency_title, radio_title=radio_title, *args, **kwargs)

    def get_line(self):
        return BOARDERS['horizontal_dual']

    def get_spacer(self, last, border):
        if border and last:
            return BOARDERS['bottom_right']
        elif last:
            return BOARDERS['bottom_dual']
        else:
            return BOARDERS['bottom_single']


class FrequencyBorderBottom(FrequencyBorder):
    def __init__(self, border=False, frequency_title=None, radio_group=None):
        super(FrequencyBorderBottom, self).__init__(part=RadioBorderBottom, border=border,
                                                    frequency_title=frequency_title, radio_group=radio_group)


class StationBorderBottom(StationBorder):
    def __init__(self, station_title=None):
        super(StationBorderBottom, self).__init__(part='bottom', station_title=station_title)


class Bottom(Line):
    def __init__(self, frequency_children=None, radio_children=None):
        super(Bottom, self).__init__(StationBorderBottom, FrequencyBorderBottom,
                                     frequency_children=frequency_children, radio_children=radio_children)
