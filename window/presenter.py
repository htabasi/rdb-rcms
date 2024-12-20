import unicurses as uc
from datetime import datetime, UTC
from .color import Colors


class Row:
    i = 0

    def __init__(self, level, category, sender, message, date=None, utctime=False):
        if date is None:
            self.date = datetime.now(UTC) if utctime else datetime.now()
        else:
            self.date = date

        Row.i += 1
        self.number = Row.i
        self.level = level
        self.category = category
        self.sender = sender
        self.message = message

    def __repr__(self):
        return (f"{self.number:^5} {self.date.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]} {self.level} {self.category}"
                f"{self.sender} {self.message}")


class FieldPresenter:
    def __init__(self, window, color: Colors, title, w_ratio, pw, min_w, max_w=None, align='<'):
        self.window = window
        self.color = color
        self.title = title
        self.min_w = min_w
        self.max_w = max_w
        self.w_ratio = w_ratio
        self.parent_width = pw
        self.align = align

        cw = int(round(w_ratio * pw))
        if max_w is None:
            max_w = cw

        if min_w <= cw <= max_w:
            self.width = cw
        elif cw < min_w:
            self.width = min_w
        else:
            self.width = max_w

    def convert(self, field):
        if type(field) is str:
            return field
        else:
            return str(field)

    def arranging(self, field):
        text = self.convert(field)
        pad = ' '
        if self.align == '^':
            w = (self.width - len(text)) // 2
            return pad * w + text + pad * (self.width - len(text) - w)
        elif self.align == '>':
            return pad * (self.width - len(text)) + text
        else:
            return text + pad * (self.width - len(text))

    def put(self, y, x, level, field, value):
        color = self.color.get_color(level, field)
        uc.wattron(self.window, color)
        uc.mvwaddstr(self.window, y, x, self.arranging(value))
        uc.wattroff(self.window, color)

    def put_title(self, y, x, c):
        uc.wattron(self.window, self.color.color(c))
        w = self.width - len(self.title) // 2
        title = ' ' * w + self.title + ' ' * (self.width - w)
        uc.mvwaddstr(self.window, y, x, title)
        uc.wattroff(self.window, self.color.color(self.color.bg))


class NumberFieldPresenter(FieldPresenter):
    def __init__(self, window, color, parent_width, align='^'):
        super().__init__(window, color, 'No.', 0.05, parent_width, 7, align=align)


class DateFieldPresenter(FieldPresenter):
    def __init__(self, window, color, parent_width, align='<'):
        super().__init__(window, color, 'Date', 0.18, parent_width, 23, align=align)

    def convert(self, date: datetime):
        return date.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]


class LevelFieldPresenter(FieldPresenter):
    def __init__(self, window, color, parent_width, align='<'):
        super().__init__(window, color, 'Level', 0.1, parent_width, 11, align=align)


class CategoryFieldPresenter(FieldPresenter):
    """
    Manager
    Connection
    Alive
    Message
    """

    def __init__(self, window, color, parent_width, align='<'):
        super().__init__(window, color, 'Category', 0.09, parent_width, 11, align=align)


class SenderFieldPresenter(FieldPresenter):
    def __init__(self, window, color, parent_width, align='<'):
        super().__init__(window, color, 'Sender', 0.1, parent_width, 13, align=align)


class MessageFieldPresenter(FieldPresenter):
    def __init__(self, window, color, parent_width, align='<'):
        super().__init__(window, color, 'Message', 0.49, parent_width, 50, align=align)


class RowPresenter:
    def __init__(self, window, color, width):
        self.window = window
        self.width = width
        self.number_presenter = NumberFieldPresenter(window, color, width)
        self.date_presenter = DateFieldPresenter(window, color, width)
        self.level_presenter = LevelFieldPresenter(window, color, width)
        self.category_presenter = CategoryFieldPresenter(window, color, width)
        self.sender_presenter = SenderFieldPresenter(window, color, width)
        self.message_presenter = MessageFieldPresenter(window, color, width)
        self.x = [1]
        self.x.append(self.x[-1] + self.number_presenter.width)
        self.x.append(self.x[-1] + self.date_presenter.width)
        self.x.append(self.x[-1] + self.level_presenter.width)
        self.x.append(self.x[-1] + self.category_presenter.width)
        self.x.append(self.x[-1] + self.sender_presenter.width)
        self.x.append(self.x[-1] + self.message_presenter.width)

    def put(self, y, row: Row):
        self.number_presenter.put(y, self.x[0], row.level, 'Number', row.number)
        self.date_presenter.put(y, self.x[1], row.level, 'Date', row.date)
        self.level_presenter.put(y, self.x[2], row.level, 'Level', row.level)
        self.category_presenter.put(y, self.x[3], row.level, 'Category', row.category)
        self.sender_presenter.put(y, self.x[4], row.level, 'Sender', row.sender)
        self.message_presenter.put(y, self.x[5], row.level, 'Message', row.message)

    def put_free(self, y):
        uc.wattron(self.window, 50)
        uc.mvwaddstr(self.window, y, self.x[0], ' ' * self.width)
        uc.wattroff(self.window, 50)
