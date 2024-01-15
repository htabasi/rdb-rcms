from dbdriver import get_connection, get_file, get_multiple_row, execute_no_answer_query
from datetime import datetime
from time import sleep
from threading import Thread


class GroupCommand(Thread):
    """
    radios:
        = {
        'BUZ': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'KMS': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'BJD': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'ISN': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'ANK': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'BND': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'MSD': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'TBZ': {1: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                2: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']},
                3: {'RX': ['M', 'S'],
                    'TX': ['M', 'S']}},
        'WSP': {1: {'RX': ['M'],
                    'TX': ['M']},
                2: {'TX': ['M']}}}

    """

    def __init__(self, radios: list[str], termination_command):
        super(GroupCommand, self).__init__(name=f"Group_Commander", daemon=True)

        self.terminate = termination_command
        self.rtype = {0: 'TX', 1: 'RX'}
        self.main_standby = {0: 'M', 1: 'S'}
        self.insert = get_file('dbfiles/insert/command_history.sql')
        self.select = get_file('dbfiles/select/manager_command_history.sql')
        self.update = get_file('dbfiles/update/manager_command_history.sql')
        self.connection = None
        self.timing = 1
        self.radios = {}
        for radio_name in radios:
            station = radio_name[:3]
            freq = int(radio_name[8])
            radio = radio_name[4:6]
            if station not in self.radios:
                self.radios[station] = {}
            if freq not in self.radios[station]:
                self.radios[station][freq] = {}
            if radio not in self.radios[station][freq]:
                self.radios[station][freq][radio] = []
            ms = radio_name[-1]
            self.radios[station][freq][radio].append(ms)

    @staticmethod
    def name(station, freq, rtype, main_standby):
        return f"{station}_{rtype}_V{freq}{main_standby}"

    def get_radio_list(self, station, freq, rtype, main_standby):
        radio_names = []
        if station == 'ALL':
            if freq == 0:
                if rtype == 2:
                    if main_standby == 2:
                        for s in self.radios:
                            for f in self.radios[s]:
                                for r in self.radios[s][f]:
                                    for p in self.radios[s][f][r]:
                                        radio_names.append(self.name(s, f, r, p))

                    else:
                        for s in self.radios:
                            for f in self.radios[s]:
                                for r in self.radios[s][f]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[s][f][r]:
                                        radio_names.append(self.name(s, f, r, p))

                else:
                    if main_standby == 2:
                        for s in self.radios:
                            for f in self.radios[s]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[s][f]:
                                    for p in self.radios[s][f][r]:
                                        radio_names.append(self.name(s, f, r, p))

                    else:
                        for s in self.radios:
                            for f in self.radios[s]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[s][f]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[s][f][r]:
                                        radio_names.append(self.name(s, f, r, p))
            else:
                if rtype == 2:
                    if main_standby == 2:
                        for s in self.radios:
                            if freq in self.radios[s]:
                                for r in self.radios[s][freq]:
                                    for p in self.radios[s][freq][r]:
                                        radio_names.append(self.name(s, freq, r, p))

                    else:
                        for s in self.radios:
                            if freq in self.radios[s]:
                                for r in self.radios[s][freq]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[s][freq][r]:
                                        radio_names.append(self.name(s, freq, r, p))

                else:
                    if main_standby == 2:
                        for s in self.radios:
                            if freq in self.radios[s]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[s][freq]:
                                    for p in self.radios[s][freq][r]:
                                        radio_names.append(self.name(s, freq, r, p))

                    else:
                        for s in self.radios:
                            if freq in self.radios[s]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[s][freq]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[s][freq][r]:
                                        radio_names.append(self.name(s, freq, r, p))

        else:
            if freq == 0:
                if rtype == 2:
                    if main_standby == 2:
                        if station in self.radios:
                            for f in self.radios[station]:
                                for r in self.radios[station][f]:
                                    for p in self.radios[station][f][r]:
                                        radio_names.append(self.name(station, f, r, p))

                    else:
                        if station in self.radios:
                            for f in self.radios[station]:
                                for r in self.radios[station][f]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[station][f][r]:
                                        radio_names.append(self.name(station, f, r, p))

                else:
                    if main_standby == 2:
                        if station in self.radios:
                            for f in self.radios[station]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[station][f]:
                                    for p in self.radios[station][f][r]:
                                        radio_names.append(self.name(station, f, r, p))

                    else:
                        if station in self.radios:
                            for f in self.radios[station]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[station][f]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[station][f][r]:
                                        radio_names.append(self.name(station, f, r, p))
            else:
                if rtype == 2:
                    if main_standby == 2:
                        if station in self.radios:
                            if freq in self.radios[station]:
                                for r in self.radios[station][freq]:
                                    for p in self.radios[station][freq][r]:
                                        radio_names.append(self.name(station, freq, r, p))

                    else:
                        if station in self.radios:
                            if freq in self.radios[station]:
                                for r in self.radios[station][freq]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[station][freq][r]:
                                        radio_names.append(self.name(station, freq, r, p))

                else:
                    if main_standby == 2:
                        if station in self.radios:
                            if freq in self.radios[station]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[station][freq]:
                                    for p in self.radios[station][freq][r]:
                                        radio_names.append(self.name(station, freq, r, p))

                    else:
                        if station in self.radios:
                            if freq in self.radios[station]:
                                r = self.rtype.get(rtype)
                                if r in self.radios[station][freq]:
                                    p = self.main_standby.get(main_standby)
                                    if p in self.radios[station][freq][r]:
                                        radio_names.append(self.name(station, freq, r, p))

        return radio_names

    def get_query(self, station, freq, rtype, main_standby, key, request, value):
        radio_names = self.get_radio_list(station, freq, rtype, main_standby)
        return (self.insert +
                "".join([f"('{radio_name}', '{key}', '{request}', '{value}', 1), "
                         for radio_name in radio_names])[:-2] + ';')

    def run(self):
        self.connection = get_connection()
        while not self.terminate[0]:
            answer = get_multiple_row(self.connection, self.select)
            if answer is not None:
                for command_args in answer:
                    self.read_and_export_commands(*command_args)
                    sleep(1)

            sleep(self.timing)
        self.connection.close()

    def read_and_export_commands(self, _id, *args):
        self.update_database(_id, 2)
        # id, Station, Frequency, RadioType, MainStandby, CKey, Request, Value
        if args[3] == 2 or args[0] == 'ALL':
            print('SecurityError')
            self.update_database(_id, 5)
        else:
            execute_no_answer_query(self.connection, self.get_query(*args))
            self.update_database(_id, 4)

    def update_database(self, _id, stat):
        now = str(datetime.now())[:23]
        execute_no_answer_query(self.connection, self.update.format(now, stat, _id))


def group_command_tester():
    from dbdriver import get_simple_column

    con = get_connection()
    radio_list = get_simple_column(con, "Select Radio_Name From Common.Radio;")
    con.close()
    term_com = [False]
    group = GroupCommand(radio_list, term_com)
    group.start()
    # print(group.get_radio_list('ALL', 0, 0, 0))
    # print(group.get_query('ALL', 0, 2, 2, 'SCSS', 'S', 2))
    for t in range(120, 0, -1):
        print(f'\rTest Exit Timer {t}', end="")
        sleep(1)

    term_com[0] = True
    group.join()


if __name__ == '__main__':
    group_command_tester()