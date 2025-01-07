from prompt_toolkit.layout import Layout, VSplit, HorizontalAlign, HSplit, VerticalAlign

from director.panel import WIDTH
from director.panel.lines.bottom import Bottom
from director.panel.lines.inside import Inside
from director.panel.lines.second import Second
from director.panel.lines.third import Third
from director.panel.lines.top import Top
from director.panel.station import Station
from director.panel.title.frequency import FrequencyTitle, StationTitle
from director.panel.title.radio import RadioGroupTitle, FreeTitle
from director.panel.title.main import MainTitle


class Panel(Layout):
    def __init__(self, stations: dict):
        self.main_title = MainTitle('In The Name of ALLAH', 'IRAN RCMS', 'Radio module management software')
        self.frequency_row = VSplit([StationTitle(), FrequencyTitle(1), FrequencyTitle(2), FrequencyTitle(3)],
                               align=HorizontalAlign.LEFT, width=WIDTH['panel_column'], height=1)
        self.radio_group_row = VSplit([FreeTitle(self.frequency_row.children[0]),
                                       RadioGroupTitle(), RadioGroupTitle(), RadioGroupTitle()],
                                 align=HorizontalAlign.LEFT, width=WIDTH['panel_column'], height=1)

        self.rows = HSplit([Top(), self.main_title, Second(), self.frequency_row, self.radio_group_row,
                            Third(self.frequency_row.children, self.radio_group_row.children)],
                           align=VerticalAlign.TOP)
        self.fixed_children = self.rows.children.copy()
        # self.fixed_children = [Top(), self.main_title, Second(), self.frequency_row, self.radio_group_row, Third()]
        self.stations = stations.copy()
        self.station_code = {station['name']: code for code, station in self.stations.items()}
        self.refresh()
        super().__init__(self.rows)

    def update_status(self, station, frequency, radio, left, right):
        code = self.station_code[station]
        self.stations[code]['station'].panel[frequency].panel[radio].set_color(left, right)

    def refresh(self):
        self.rows.children.clear()
        self.rows.children.extend(self.fixed_children)

        l = len(self.stations)
        for i, code in enumerate(sorted(self.stations.keys())):
            name, fc = self.stations[code]['name'], self.stations[code]['fc']
            station = Station(code, name, self.frequency_row, self.radio_group_row, fc)
            self.stations[code]['station'] = station
            self.rows.children.append(station)

            if i < l - 1:
                self.rows.children.append(Inside(self.frequency_row.children, self.radio_group_row.children))

        self.rows.children.append(Bottom())

    def add_station(self, name, code, fc):
        self.stations[code] = {'name': name, 'fc': fc}
        self.station_code[name] = code
        self.refresh()

    def remove_station(self, name):
        code = self.station_code[name]
        self.remove_code(code)
        self.station_code.pop(name)

    def remove_code(self, code):
        if code in self.stations:
            self.stations.pop(code)
            self.refresh()
