from director.panel import BOARDERS
from director.panel.lines import RadioBorder, FrequencyBorder, StationBorder, Line


class RadioBorderDual(RadioBorder):
    def __init__(self, frequency_title=None, radio_title=None, *args, **kwargs):
        super().__init__(part='third', frequency_title=frequency_title, radio_title=radio_title, *args, **kwargs)

    def get_line(self):
        return BOARDERS['horizontal_dual']

    def get_spacer(self, last, border):
        if border and last:
            return BOARDERS['right_dual']
        elif last:
            return BOARDERS['cross_dual_dual']
        else:
            return BOARDERS['cross_dual_single']


class FrequencyBorderDual(FrequencyBorder):
    def __init__(self, border=False, frequency_title=None, radio_group=None):
        super(FrequencyBorderDual, self).__init__(part=RadioBorderDual, border=border,
                                                  frequency_title=frequency_title, radio_group=radio_group)


class StationBorderDual(StationBorder):
    def __init__(self, station_title):
        super(StationBorderDual, self).__init__(part='third', station_title=station_title)


class Third(Line):
    def __init__(self, frequency_children=None, radio_children=None):
        super(Third, self).__init__(StationBorderDual, FrequencyBorderDual,
                                    frequency_children=frequency_children, radio_children=radio_children)
