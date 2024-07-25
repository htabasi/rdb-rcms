RX, TX = 0, 1


def str_convert(value: str):
    return f'"{value}"'


def multi_int_convert(value: tuple[int, ...]):
    return str(value).replace(' ', '')[1:-1]


def multi_string_convert(value: tuple[str, ...]):
    return f'{len(value)},' + ",".join([f'"{p}"' for p in value])


def multi_ip_convert(value: tuple[str, ...]):
    return f'{len(value)},' + ",".join([f'"::{p}"' for p in value])


def multi_tuple_convert(value: tuple[tuple, ...]):
    return f'{len(value)},' + ",".join([str(p).replace(' ', '')[1:-1] for p in value])


def command_constructor(key: str, converted_value: any, command: str, command_number: int):
    pc, sc = key[:2], key[2:]
    return f'M:{pc} {command_number} {command}{sc}{converted_value}'


def single_int(key: str, value: int, command: str, command_number: int):
    """ M:SC 96 SSS2 """
    return command_constructor(key, value, command, command_number)


def single_string(key: str, value: str, command: str, command_number: int):
    """ M:GR 319 SIN"TX-V1S" """
    return command_constructor(key, str_convert(value), command, command_number)


def single_none(key: str, value: None, command: str, command_number: int):
    """ M:RC 156 SRR """
    return command_constructor(key, '', command, command_number)


def multi_int(key: str, value: tuple[int, ...], command: str, command_number: int):
    """ M:GR 353 SNC1,2,101,1 """
    return command_constructor(key, multi_int_convert(value), command, command_number)


def multi_string(key: str, value: tuple[str, ...], command: str, command_number: int):
    """ M:GR 320 SLO10,"KIS TX 133.4 S","","","","","","","","","" """
    return command_constructor(key, multi_string_convert(value), command, command_number)


def multi_ip(key: str, value: tuple[str, ...], command: str, command_number: int):
    """ M:GR 324 SII3,"::192.168.52.202","::255.255.255.0","::192.168.52.1" """
    return command_constructor(key, multi_ip_convert(value), command, command_number)


def multi_tuple(key: str, value: tuple[tuple, ...], command: str, command_number: int):
    """ M:FF 114 SBL8,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0 """
    return command_constructor(key, multi_tuple_convert(value), command, command_number)


def unknown(*args):
    print('Not Implemented yet on ', *args)


class Constructor:
    def __init__(self, log, radio_code: int = RX):
        self.log = log
        self.get_commands = {'AIAD', 'AIAI', 'AIEL', 'AILA', 'AISE', 'AISF', 'AISL', 'ERBE', 'ERGN', 'EVEL', 'EVSR',
                             'FFBL', 'FFEA', 'FFFC', 'FFFE', 'FFLM', 'FFLT', 'FFMD', 'FFSC', 'FFSP', 'FFTR', 'GRAC',
                             'GRCS', 'GRDH', 'GRDN', 'GRDS', 'GRHN', 'GRIE', 'GRII', 'GRIL', 'GRIN', 'GRIP', 'GRIV',
                             'GRLO', 'GRME', 'GRNA', 'GRNC', 'GRND', 'GRNS', 'GRSE', 'GRSN', 'GRSV', 'GRTI', 'GRUI',
                             'GRVE', 'MSAC', 'MSTY', 'RCMV', 'RCOC', 'RCPP', 'RCPV', 'RCTP', 'RUFL', 'RUFP', 'SCPG',
                             'SCSL', 'SCSS'}
        self.set_commands = {'AIAD', 'AIAI', 'AIEL', 'AILA', 'AISE', 'AISF', 'AISL', 'EVCL', 'FFBL', 'FFEA', 'FFFE',
                             'FFLM', 'FFLT', 'FFMD', 'FFSC', 'FFSP', 'FFTR', 'GRAC', 'GRAT', 'GRDH', 'GRDN', 'GRIE',
                             'GRII', 'GRIN', 'GRIP', 'GRIV', 'GRLO', 'GRME', 'GRNC', 'GRNS', 'GRSE', 'GRSN', 'MSAC',
                             'MSGO', 'MSTY', 'RCPP', 'RCPV', 'RCRR', 'SCPG', 'SCSS'}
        self.trap_commands = {'AIAD', 'AILA', 'AISL', 'ERGN', 'EVEE', 'FFMD', 'FFSP', 'FFTR', 'GRCS', 'GRDS', 'GRHN',
                              'GRII', 'GRIP', 'GRME', 'GRNA', 'GRNS', 'GRTI', 'GRUI', 'MSAC', 'RCMV', 'RCPP', 'RCTP',
                              'SCSL', 'SCSS'}

        self.get_need_value = {'GRIL', 'GRND'}
        self.update_need_restart = {'AIAI', 'AICA', 'AIEL', 'AIGA', 'AIML', 'AISE', 'AISF', 'AITS', 'FFBL', 'FFCO',
                                    'FFEA', 'FFFE', 'FFLM', 'FFLT', 'FFSC', 'FFSL', 'GRAC', 'GRAS', 'GRBS', 'GRCO',
                                    'GRDH', 'GRDN', 'GREX', 'GRIE', 'GRII', 'GRIN', 'GRIP', 'GRIS', 'GRIV', 'GRLO',
                                    'GRNC', 'GRNS', 'GRSE', 'GRSN', 'MSTY', 'RCDP', 'RCPV', 'RIPC', 'RIRO', 'RIVL',
                                    'RIVP', 'RUFL', 'RUFP'}

        self.converter = {
            'EVCL': single_none,
            'FFBL': multi_tuple,
            'GRAC': multi_ip,
            'GRAT': single_none,
            'GRDN': multi_ip,
            'GRII': multi_ip,
            'GRIN': single_string,
            'GRIP': multi_ip,
            'GRLO': multi_string,
            'GRNC': multi_int,
            'GRNS': single_string,
            'GRSN': single_string,
            'MSGO': single_none,
            'RCPP': unknown,
            'RCPV': unknown,
            'RCRR': single_none,
            'RUFL': single_string,
            'RUFP': single_string,
            'SCPG': single_int,
        }

        if radio_code == TX:  # TX
            self.get_commands = self.get_commands.union(
                {'AICA', 'AIML', 'AITP', 'FFTO', 'GRAS', 'GRCO', 'GREX', 'GRLT', 'RCDP', 'RCIT', 'RCLP', 'RCLV', 'RCMG',
                 'RCMO', 'RCNP', 'RCTC', 'RCTO', 'RCTS', 'RCTV', 'RCTW', 'RCVV', 'RIPC', 'RIVL', 'RIVP'})

            self.set_commands = self.set_commands.union(
                {'AICA', 'AIML', 'AITP', 'FFTO', 'GRAS', 'GRCO', 'GREX', 'RCDP', 'RCIT', 'RCLP', 'RCMG', 'RCNP', 'RCPF',
                 'RCPT', 'RCTS', 'RIPC', 'RIVL', 'RIVP'})

            self.trap_commands = self.trap_commands.union(
                {'RCLV', 'RCMG', 'RCMO', 'RCTC', 'RCTO', 'RCTV', 'RCTW', 'RCVV'})
            # self.converter.update({})

        else:  # RX
            self.get_commands = self.get_commands.union(
                {'AIGA', 'AITS', 'FFCO', 'FFRS', 'FFSL', 'FFSN', 'FFSQ', 'FFSR', 'GRBS', 'GRIS', 'GRLR', 'RCLR',
                 'RCRI', 'RIRC', 'RIRO'})

            self.set_commands = self.set_commands.union(
                {'AIGA', 'AITS', 'FFCO', 'FFSL', 'FFSN', 'FFSQ', 'FFSR', 'GRBS', 'GRIS', 'RIRO'})

            self.trap_commands = self.trap_commands.union({'FFRS', 'FFSN', 'FFSQ', 'FFSR', 'RCLR', 'RCRI', 'RIRC'})
            # self.converter.update({})

    def convert(self, command_number, key, request, value):
        self.log.debug(f'Converting command: {key} {request} {value}')
        if request == 'T':
            if key not in self.trap_commands:
                self.log.error(f'Error in  Trap set: {key}')
            return single_int(key, value, request, command_number)
        elif request == 'S':
            if key not in self.set_commands:
                self.log.error(f'Error in  Set set: {key}')
            return self.converter.get(key, single_int)(key, value, request, command_number)
        elif request == 'G':
            if key not in self.get_commands:
                self.log.error(f'Error in  Get set: {key}')
            if key in self.get_need_value:
                return single_int(key, value, request, command_number)
            else:
                return single_none(key, None, request, command_number)


def rx_test_construct():
    c = Constructor(1)
    print(c.convert('SCSS', 2, 'S', 96))
    print(c.convert('GRIV', 0, 'S', 105))
    print(c.convert('GRIE', 1, 'S', 106))
    print(c.convert('GRDH', 0, 'S', 107))
    print(c.convert('GRIN', "", 'S', 108))
    print(c.convert('GRLO', ("", "", "", "", "", "", "", "", "", ""), 'S', 109))
    print(c.convert('FFSC', 0, 'S', 110))
    print(c.convert('MSTY', 0, 'S', 111))
    print(c.convert('GRIP', ("192.168.16.11", "255.255.255.0", "192.168.16.1"), 'S', 112))
    print(c.convert('GRII', ("192.168.52.201", "255.255.255.0", "192.168.52.1"), 'S', 113))
    print(c.convert('FFBL', ((2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0)),
                    'S', 114))
    print(c.convert('GRAC', ("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
                    'S', 115))
    print(c.convert('FFLM', 1, 'S', 116))
    print(c.convert('AIEL', 1, 'S', 117))
    print(c.convert('AITS', 1, 'S', 118))
    print(c.convert('AIGA', 0, 'S', 119))
    print(c.convert('GRIS', 0, 'S', 120))
    print(c.convert('FFEA', 0, 'S', 121))
    print(c.convert('FFSL', 0, 'S', 122))
    print(c.convert('FFLT', 0, 'S', 123))
    print(c.convert('FFFE', 0, 'S', 124))
    print(c.convert('AISE', 0, 'S', 125))
    print(c.convert('AISF', 2440, 'S', 126))
    print(c.convert('RIRO', 0, 'S', 127))
    print(c.convert('GRSN', "public", 'S', 128))
    print(c.convert('GRSE', 0, 'S', 129))
    print(c.convert('GRBS', 0, 'S', 130))
    print(c.convert('AIAI', 0, 'S', 131))
    print(c.convert('FFCO', 1, 'S', 132))
    print(c.convert('GRDN', ("", ""), 'S', 133))
    print(c.convert('RUFL', "", 'S', 134))
    print(c.convert('RUFP', "", 'S', 135))
    print(c.convert('GRNS', "0.0.0.0", 'S', 136))
    print(c.convert('GRME', 1702465476, 'S', 137))
    print(c.convert('GRNC', (1, 2, 101, 2), 'S', 140))
    print(c.convert('GRNC', (1, 2, 103, 2), 'S', 141))
    print(c.convert('GRNC', (1, 2, 201, 2), 'S', 142))
    print(c.convert('GRNC', (1, 2, 401, 1), 'S', 143))
    print(c.convert('GRNC', (1, 2, 402, 1), 'S', 144))
    print(c.convert('GRNC', (1, 2, 414, 1), 'S', 145))
    print(c.convert('GRNC', (1, 2, 415, 1), 'S', 146))
    print(c.convert('GRNC', (1, 2, 430, 1), 'S', 147))
    print(c.convert('GRNC', (1, 2, 435, 4), 'S', 148))
    print(c.convert('GRNC', (1, 2, 436, 4), 'S', 149))
    print(c.convert('GRNC', (1, 2, 437, 2), 'S', 150))
    print(c.convert('GRNC', (1, 2, 438, 2), 'S', 151))
    print(c.convert('GRME', 1702465490, 'S', 152))
    print(c.convert('RCRR', None, 'S', 156))


def tx_test_construct():
    c = Constructor(0)
    print(c.convert('AIAI', 0, 'S', 342))
    print(c.convert('AICA', 0, 'S', 330))
    print(c.convert('AIEL', 1, 'S', 329))
    print(c.convert('AIML', 0, 'S', 344))
    print(c.convert('AISE', 0, 'S', 338))
    print(c.convert('AISF', 2040, 'S', 339))
    print(c.convert('FFBL', ((2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0)),
                    'S', 326))
    print(c.convert('FFEA', 0, 'S', 333))
    print(c.convert('FFFE', 0, 'S', 337))
    print(c.convert('FFLM', 1, 'S', 328))
    print(c.convert('FFLT', 60, 'S', 336))
    print(c.convert('FFSC', 0, 'S', 321))
    print(c.convert('GRAC', ("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
                    'S', 327))
    print(c.convert('GRAS', 0, 'S', 345))
    print(c.convert('GRCO', 0, 'S', 325))
    print(c.convert('GRDH', 0, 'S', 318))
    print(c.convert('GRDN', ("", ""), 'S', 346))
    print(c.convert('GREX', 0, 'S', 343))
    print(c.convert('GRIE', 0, 'S', 317))
    print(c.convert('GRII', ("192.168.52.202", "255.255.255.0", "192.168.52.1"), 'S', 324))
    print(c.convert('GRIN', "TX-V1S", 'S', 319))
    print(c.convert('GRIP', ("192.168.16.32", "255.255.255.0", "192.168.16.1"), 'S', 323))
    print(c.convert('GRIV', 0, 'S', 316))
    print(c.convert('GRLO', ("KIS TX 133.4 S", "", "", "", "", "", "", "", "", ""), 'S', 320))
    print(c.convert('GRME', 1702465626, 'S', 350))
    print(c.convert('GRME', 1702465633, 'S', 368))
    print(c.convert('GRNC', (1, 2, 101, 1), 'S', 353))
    print(c.convert('GRNC', (1, 2, 103, 4), 'S', 354))
    print(c.convert('GRNC', (1, 2, 201, 4), 'S', 355))
    print(c.convert('GRNC', (1, 2, 301, 1), 'S', 356))
    print(c.convert('GRNC', (1, 2, 302, 1), 'S', 357))
    print(c.convert('GRNC', (1, 2, 323, 4), 'S', 358))
    print(c.convert('GRNC', (1, 2, 331, 4), 'S', 359))
    print(c.convert('GRNC', (1, 2, 335, 2), 'S', 360))
    print(c.convert('GRNC', (1, 2, 336, 2), 'S', 361))
    print(c.convert('GRNC', (1, 2, 338, 1), 'S', 362))
    print(c.convert('GRNC', (1, 2, 342, 1), 'S', 363))
    print(c.convert('GRNC', (1, 2, 345, 1), 'S', 364))
    print(c.convert('GRNC', (1, 2, 346, 1), 'S', 365))
    print(c.convert('GRNC', (1, 2, 347, 2), 'S', 366))
    print(c.convert('GRNC', (1, 2, 348, 2), 'S', 367))
    print(c.convert('GRNS', "192.168.8.1", 'S', 349))
    print(c.convert('GRSE', 1, 'S', 341))
    print(c.convert('GRSN', "public", 'S', 340))
    print(c.convert('MSTY', 0, 'S', 322))
    print(c.convert('RCDP', 300, 'S', 331))
    print(c.convert('RCRR', None, 'S', 372))
    print(c.convert('RCRR', None, 'S', 374))
    print(c.convert('RIPC', 2, 'S', 332))
    print(c.convert('RIVL', 2, 'S', 334))
    print(c.convert('RIVP', 0, 'S', 335))
    print(c.convert('RUFL', "rcag", 'S', 347))
    print(c.convert('RUFP', "rcag", 'S', 348))
    print(c.convert('SCSS', 2, 'S', 313))


if __name__ == '__main__':
    # c = SingleInteger('SCSS', 2)
    # c = SingleString('GRIN', 'TX-V1S', 'S')
    # c = MultiInteger('GRNC', (1, 2, 101, 1), 'S')
    # c = MultiString('GRLO', ('KIS TX 133.4 S', '', '', '', '', '', '', '', '', ''), 'S')
    # c = MultiIP('GRIP', ('192.168.16.11', '255.255.255.0', '192.168.16.1'))
    # c = MultiTuple('FFBL', ((2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0),
    #                         (2, 0, 0), (2, 0, 0), (2, 0, 0), (2, 0, 0)), 'S')

    # print(str(c).format(112))
    # print('M:FF 114 SBL8,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0')
    # print('M:GR 112 SIP3,"::192.168.16.11","::255.255.255.0","::192.168.16.1"')
    # print(command_constructor('SCSS', int_convert(2), 'S', 100))
    c = Constructor(0)
    # print(c.convert('SCSS', 2, 'S', 96))
    # rx_test_construct()
    # tx_test_construct()

    print(c.convert('SCSS', 0, 'T', 96))
