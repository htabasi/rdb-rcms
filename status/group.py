from status.frequency import Frequency


class Group:
    def __init__(self, name):
        self.name = name
        self.frequencies = []

    def add_frequency(self, new: Frequency):
        self.frequencies.append(new)

    def update_status(self, connection, df):
        for f in self.frequencies:
            f.update_status(connection, df)

    def __repr__(self):
        s = f'Group {self.name}:\n'
        for f in self.frequencies:
            s += f'    {f}\n'
        return s


class Sector(Group):
    pass


class Station(Group):
    pass