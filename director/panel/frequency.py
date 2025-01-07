from prompt_toolkit.layout.containers import VSplit, HorizontalAlign

from director.panel import WIDTH
from director.panel.radio import Radio, NoRadio


class Frequency(VSplit):
    def __init__(self, frequency_title, radio_title):
        self.panel = {'TXM': Radio(frequency_title, radio_title.panel['TXM']),
                      'TXS': Radio(frequency_title, radio_title.panel['TXS']),
                      'RXM': Radio(frequency_title, radio_title.panel['RXM']),
                      'RXS': Radio(frequency_title, radio_title.panel['RXS'], last=True)}
        super().__init__([self.panel['TXM'], self.panel['TXS'], self.panel['RXM'], self.panel['RXS']],
                         align=HorizontalAlign.LEFT, width=WIDTH['frequency_column'], height=1)

    def set_radio_stat(self, radio, rm, c):
        self.panel[radio].set_color(rm, c)

class NoFrequency(VSplit):
    def __init__(self, frequency_title, radio_title):
        self.panel = {'TXM': NoRadio(frequency_title, radio_title.panel['TXM']),
                      'TXS': NoRadio(frequency_title, radio_title.panel['TXS']),
                      'RXM': NoRadio(frequency_title, radio_title.panel['RXM']),
                      'RXS': NoRadio(frequency_title, radio_title.panel['RXS'], last=True)}
        super().__init__([self.panel['TXM'], self.panel['TXS'], self.panel['RXM'], self.panel['RXS']],
                         align=HorizontalAlign.LEFT, width=WIDTH['frequency_column'], height=1)

