import unicurses as uc

class Colors:
    def __init__(self):
        self.name = {}
        uc.init_pair(1, uc.COLOR_BLACK, uc.COLOR_RED)
        self.name[1] = 'BLACK over RED'
        uc.init_pair(2, uc.COLOR_BLACK, uc.COLOR_GREEN)
        self.name[2] = 'BLACK over GREEN'
        uc.init_pair(3, uc.COLOR_BLACK, uc.COLOR_YELLOW)
        self.name[3] = 'BLACK over YELLOW'
        uc.init_pair(4, uc.COLOR_BLACK, uc.COLOR_BLUE)
        self.name[4] = 'BLACK over BLUE'
        uc.init_pair(5, uc.COLOR_BLACK, uc.COLOR_MAGENTA)
        self.name[5] = 'BLACK over MAGENTA'
        uc.init_pair(6, uc.COLOR_BLACK, uc.COLOR_CYAN)
        self.name[6] = 'BLACK over CYAN'
        uc.init_pair(7, uc.COLOR_BLACK, uc.COLOR_WHITE)
        self.name[7] = 'BLACK over WHITE'
        uc.init_pair(8, uc.COLOR_RED, uc.COLOR_BLACK)
        self.name[8] = 'RED over BLACK'
        uc.init_pair(9, uc.COLOR_RED, uc.COLOR_GREEN)
        self.name[9] = 'RED over GREEN'
        uc.init_pair(10, uc.COLOR_RED, uc.COLOR_YELLOW)
        self.name[10] = 'RED over YELLOW'
        uc.init_pair(11, uc.COLOR_RED, uc.COLOR_BLUE)
        self.name[11] = 'RED over BLUE'
        uc.init_pair(12, uc.COLOR_RED, uc.COLOR_MAGENTA)
        self.name[12] = 'RED over MAGENTA'
        uc.init_pair(13, uc.COLOR_RED, uc.COLOR_CYAN)
        self.name[13] = 'RED over CYAN'
        uc.init_pair(14, uc.COLOR_RED, uc.COLOR_WHITE)
        self.name[14] = 'RED over WHITE'
        uc.init_pair(15, uc.COLOR_GREEN, uc.COLOR_BLACK)
        self.name[15] = 'GREEN over BLACK'
        uc.init_pair(16, uc.COLOR_GREEN, uc.COLOR_RED)
        self.name[16] = 'GREEN over RED'
        uc.init_pair(17, uc.COLOR_GREEN, uc.COLOR_YELLOW)
        self.name[17] = 'GREEN over YELLOW'
        uc.init_pair(18, uc.COLOR_GREEN, uc.COLOR_BLUE)
        self.name[18] = 'GREEN over BLUE'
        uc.init_pair(19, uc.COLOR_GREEN, uc.COLOR_MAGENTA)
        self.name[19] = 'GREEN over MAGENTA'
        uc.init_pair(20, uc.COLOR_GREEN, uc.COLOR_CYAN)
        self.name[20] = 'GREEN over CYAN'
        uc.init_pair(21, uc.COLOR_GREEN, uc.COLOR_WHITE)
        self.name[21] = 'GREEN over WHITE'
        uc.init_pair(22, uc.COLOR_YELLOW, uc.COLOR_BLACK)
        self.name[22] = 'YELLOW over BLACK'
        uc.init_pair(23, uc.COLOR_YELLOW, uc.COLOR_RED)
        self.name[23] = 'YELLOW over RED'
        uc.init_pair(24, uc.COLOR_YELLOW, uc.COLOR_GREEN)
        self.name[24] = 'YELLOW over GREEN'
        uc.init_pair(25, uc.COLOR_YELLOW, uc.COLOR_BLUE)
        self.name[25] = 'YELLOW over BLUE'
        uc.init_pair(26, uc.COLOR_YELLOW, uc.COLOR_MAGENTA)
        self.name[26] = 'YELLOW over MAGENTA'
        uc.init_pair(27, uc.COLOR_YELLOW, uc.COLOR_CYAN)
        self.name[27] = 'YELLOW over CYAN'
        uc.init_pair(28, uc.COLOR_YELLOW, uc.COLOR_WHITE)
        self.name[28] = 'YELLOW over WHITE'
        uc.init_pair(29, uc.COLOR_BLUE, uc.COLOR_BLACK)
        self.name[29] = 'BLUE over BLACK'
        uc.init_pair(30, uc.COLOR_BLUE, uc.COLOR_RED)
        self.name[30] = 'BLUE over RED'
        uc.init_pair(31, uc.COLOR_BLUE, uc.COLOR_GREEN)
        self.name[31] = 'BLUE over GREEN'
        uc.init_pair(32, uc.COLOR_BLUE, uc.COLOR_YELLOW)
        self.name[32] = 'BLUE over YELLOW'
        uc.init_pair(33, uc.COLOR_BLUE, uc.COLOR_MAGENTA)
        self.name[33] = 'BLUE over MAGENTA'
        uc.init_pair(34, uc.COLOR_BLUE, uc.COLOR_CYAN)
        self.name[34] = 'BLUE over CYAN'
        uc.init_pair(35, uc.COLOR_BLUE, uc.COLOR_WHITE)
        self.name[35] = 'BLUE over WHITE'
        uc.init_pair(36, uc.COLOR_MAGENTA, uc.COLOR_BLACK)
        self.name[36] = 'MAGENTA over BLACK'
        uc.init_pair(37, uc.COLOR_MAGENTA, uc.COLOR_RED)
        self.name[37] = 'MAGENTA over RED'
        uc.init_pair(38, uc.COLOR_MAGENTA, uc.COLOR_GREEN)
        self.name[38] = 'MAGENTA over GREEN'
        uc.init_pair(39, uc.COLOR_MAGENTA, uc.COLOR_YELLOW)
        self.name[39] = 'MAGENTA over YELLOW'
        uc.init_pair(40, uc.COLOR_MAGENTA, uc.COLOR_BLUE)
        self.name[40] = 'MAGENTA over BLUE'
        uc.init_pair(41, uc.COLOR_MAGENTA, uc.COLOR_CYAN)
        self.name[41] = 'MAGENTA over CYAN'
        uc.init_pair(42, uc.COLOR_MAGENTA, uc.COLOR_WHITE)
        self.name[42] = 'MAGENTA over WHITE'
        uc.init_pair(43, uc.COLOR_CYAN, uc.COLOR_BLACK)
        self.name[43] = 'CYAN over BLACK'
        uc.init_pair(44, uc.COLOR_CYAN, uc.COLOR_RED)
        self.name[44] = 'CYAN over RED'
        uc.init_pair(45, uc.COLOR_CYAN, uc.COLOR_GREEN)
        self.name[45] = 'CYAN over GREEN'
        uc.init_pair(46, uc.COLOR_CYAN, uc.COLOR_YELLOW)
        self.name[46] = 'CYAN over YELLOW'
        uc.init_pair(47, uc.COLOR_CYAN, uc.COLOR_BLUE)
        self.name[47] = 'CYAN over BLUE'
        uc.init_pair(48, uc.COLOR_CYAN, uc.COLOR_MAGENTA)
        self.name[48] = 'CYAN over MAGENTA'
        uc.init_pair(49, uc.COLOR_CYAN, uc.COLOR_WHITE)
        self.name[49] = 'CYAN over WHITE'
        uc.init_pair(50, uc.COLOR_WHITE, uc.COLOR_BLACK)
        self.name[50] = 'WHITE over BLACK'
        uc.init_pair(51, uc.COLOR_WHITE, uc.COLOR_RED)
        self.name[51] = 'WHITE over RED'
        uc.init_pair(52, uc.COLOR_WHITE, uc.COLOR_GREEN)
        self.name[52] = 'WHITE over GREEN'
        uc.init_pair(53, uc.COLOR_WHITE, uc.COLOR_YELLOW)
        self.name[53] = 'WHITE over YELLOW'
        uc.init_pair(54, uc.COLOR_WHITE, uc.COLOR_BLUE)
        self.name[54] = 'WHITE over BLUE'
        uc.init_pair(55, uc.COLOR_WHITE, uc.COLOR_MAGENTA)
        self.name[55] = 'WHITE over MAGENTA'
        uc.init_pair(56, uc.COLOR_WHITE, uc.COLOR_CYAN)
        self.name[56] = 'WHITE over CYAN'

        self.n = 56
        self._bg = 22
        self._sbg, self._hbg, self._tbg, self._title = 22, 29, 43, 22
        self._number, self._date, self._status, self._sender, self._message = 50, 15, 50, 50, 50
        self._debug, self._info, self._warning, self._error, self._crit = 36, 50, 22, 8, 23
        self.max_name_len = max(map(len, self.name.values()))
        self._colors = {
            'Success': {'Number': 43, 'Date': 15, 'Level': 15, 'Category': 15, 'Sender': 15, 'Message': 15},
            'Debug': {'Number': 43, 'Date': 15, 'Level': 29, 'Category': 29, 'Sender': 29, 'Message': 29},
            'Information': {'Number': 43, 'Date': 15, 'Level': 50, 'Category': 50, 'Sender': 50, 'Message': 50},
            'Notice': {'Number': 43, 'Date': 15, 'Level': 50, 'Category': 50, 'Sender': 50, 'Message': 50},
            'Warning': {'Number': 43, 'Date': 15, 'Level': 22, 'Category': 22, 'Sender': 22, 'Message': 22},
            'Error': {'Number': 43, 'Date': 15, 'Level': 8, 'Category': 8, 'Sender': 8, 'Message': 8},
            'Critical': {'Number': 43, 'Date': 15, 'Level': 23, 'Category': 23, 'Sender': 23, 'Message': 23},
            'Alert': {'Number': 43, 'Date': 15, 'Level': 23, 'Category': 23, 'Sender': 23, 'Message': 23},
            'Emergency': {'Number': 43, 'Date': 15, 'Level': 23, 'Category': 23, 'Sender': 23, 'Message': 23}
        }

    @property
    def bg(self):
        return uc.COLOR_PAIR(self._bg)

    @bg.setter
    def bg(self, n):
        self._bg = n

    @property
    def status_bg(self):
        return uc.COLOR_PAIR(self._sbg)

    @status_bg.setter
    def status_bg(self, n):
        self._sbg = n

    @property
    def hotkey_bg(self):
        return uc.COLOR_PAIR(self._hbg)

    @hotkey_bg.setter
    def hotkey_bg(self, n):
        self._hbg = n

    @property
    def table_bg(self):
        return uc.COLOR_PAIR(self._tbg)

    @table_bg.setter
    def table_bg(self, n):
        self._tbg = n

    @property
    def title(self):
        return uc.COLOR_PAIR(self._title)

    @title.setter
    def title(self, n):
        self._title = n

    def get_name(self, n):
        return self.name[n] + " " * (self.max_name_len - len(self.name[n]))

    def color(self, n):
        return uc.COLOR_PAIR(n)

    def get_color(self, level, field):
        return self.color(self._colors[level][field])

    @property
    def red_black(self):
        return uc.COLOR_PAIR(1)

    @property
    def green_black(self):
        return uc.COLOR_PAIR(2)

    @property
    def blue_black(self):
        return uc.COLOR_PAIR(3)

    @property
    def cyan_black(self):
        return uc.COLOR_PAIR(4)
