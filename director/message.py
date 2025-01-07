import logging


class MessageDirector:
    def __init__(self):
        self.file = open('messages.txt', 'w')

    def register(self, index, date, station, radio, sender, category, severity, message):
        self.file.write(f'{index:^5} {date} {station} {radio} {sender} {category:^15} {severity:^15} {message}\n')

    def close(self):
        self.file.close()

def get_log():
    f_fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}| Manager |{'{name:^14}'}|{'{message}'}"
    c_fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}| Manager |{'{name:^14}'}|{'{message}'}"

    logger = logging.getLogger('LOG')
    logger.setLevel(logging.DEBUG)

    file_handler = logging.FileHandler(f'export/Manager.log', mode='a')
    file_format = logging.Formatter(f_fmt, style='{')
    file_format.default_msec_format = '%s.%03d'
    file_handler.setFormatter(file_format)
    file_handler.setLevel(logging.DEBUG)

    console_handler = logging.StreamHandler()
    console_format = logging.Formatter(c_fmt, style='{')
    console_format.default_msec_format = '%s.%03d'
    console_handler.setFormatter(console_format)
    console_handler.setLevel(logging.ERROR)

    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger

