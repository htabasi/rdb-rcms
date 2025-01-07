from director.panel import BOARDERS
from director.panel.lines import RadioBorder, FrequencyBorder, StationBorder, Line


class RadioBorderSingle(RadioBorder):
    def __init__(self, frequency_title=None, radio_title=None, *args, **kwargs):
        super().__init__(part='inside', frequency_title=frequency_title, radio_title=radio_title, *args, **kwargs)

    def get_line(self):
        return BOARDERS['horizontal_single']

    def get_spacer(self, last, border):
        if border and last:
            return BOARDERS['right_single']
        elif last:
            return BOARDERS['cross_single_dual']
        else:
            return BOARDERS['cross_single_single']


class FrequencyBorderSingle(FrequencyBorder):
    def __init__(self, border=False, frequency_title=None, radio_group=None):
        super(FrequencyBorderSingle, self).__init__(part=RadioBorderSingle, border=border,
                                                    frequency_title=frequency_title, radio_group=radio_group)


class StationBorderSingle(StationBorder):
    def __init__(self, station_title):
        super(StationBorderSingle, self).__init__(part='inside', station_title=station_title)


class Inside(Line):
    def __init__(self, frequency_children=None, radio_children=None):
        super(Inside, self).__init__(StationBorderSingle, FrequencyBorderSingle,
                                     frequency_children=frequency_children, radio_children=radio_children)
