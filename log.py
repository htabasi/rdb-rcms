import logging


def get_configured_logger(radio, part, file_level=logging.INFO, console_level=logging.WARNING, f_fmt=None, c_fmt=None):
    """
    :param
        radio: Raio Name same as BUZ_RX_V1M
        name: Possible values ('Reception', 'Transmission', 'Core', 'Interface', 'Connector', 'Generator',
                                  'Analyzer')
    :return:
    """
    if f_fmt is None:
        f_fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}| {radio} |{'{name:^14}'}|{'{message}'}"
    if c_fmt is None:
        c_fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}| {radio} |{'{name:^14}'}|{'{message}'}"

    # logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(part)
    logger.setLevel(logging.DEBUG)

    file_handler = logging.FileHandler(f'export/{radio}.log', mode='a')
    file_format = logging.Formatter(f_fmt, style='{')
    file_format.default_msec_format = '%s.%03d'
    file_handler.setFormatter(file_format)
    file_handler.setLevel(file_level)

    console_handler = logging.StreamHandler()
    console_format = logging.Formatter(c_fmt, style='{')
    console_format.default_msec_format = '%s.%03d'
    console_handler.setFormatter(console_format)
    console_handler.setLevel(console_level)

    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    # logger.setLevel(logging.INFO)

    return logger


def get_default_loggers(radio, f_fmt=None, c_fmt=None):
    if f_fmt is None:
        f_fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}| {radio} |{'{name:^14}'}| {'{message}'}"
    if c_fmt is None:
        c_fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}| {radio} |{'{name:^14}'}| {'{message}'}"

    config = {'Reception': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt},
              'Transmission': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt},
              'Core': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt},
              'Interface': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt},
              'Connector': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt},
              'Generator': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt},
              'Analyzer': {'file_level': logging.INFO, 'console_level': logging.WARNING, 'f_fmt': f_fmt, 'c_fmt': c_fmt}}

    return {part: get_configured_logger(radio, part, **config[part]) for part in config}


def get_format(dbf, radio):
    fmt = {}
    for r in dbf:
        key = r['id']
        separator = r['separator']
        d = {}
        for item in r:
            if item in ['id', 'separator']:
                continue
            if r[item] != 0 and 'len' not in item:
                d[r[item]] = (item, r[item + '_len'])

        index_list = sorted(list(d.keys()))
        # '{asctime:<24}|{levelname:^10}| BUZ_RX_V1M |{name:^14}| {message}'
        result = ''
        for i in index_list[:-1]:
            item, ln = d[i]
            if item == 'radio':
                result += "{:^{}}".format(radio, ln) + separator
            else:
                result += "{" + item + ":^" + str(ln) + "}" + separator
        item, ln = d[index_list[-1]]
        result += " {" + item + "}"

        fmt[key] = result

    return fmt


def get_config(config, fmt):
    cnf = {}
    for d in config:
        cnf[d['App']] = {'file_level': d['FileLevel'],
                         'f_fmt': fmt[d['FileFormat']],
                         'console_level': d['StreamLevel'],
                         'c_fmt': fmt[d['StreamFormat']]}
    return cnf


def get_all_loggers(radio, config, format):
    fmt = get_format(format, radio)
    cnf = get_config(config, fmt)

    return {part: get_configured_logger(radio, part, **cnf[part]) for part in cnf}


def log_format_tester(log, radio):
    """
    Selected
        asctime:        Time
        created:        Timestamp
        filename:       log generator filename
        funcName:       log generator funcName
        levelname:      log level
        levelno:        log level number
        lineno:         line number of file that create log record
        message:         log message
        module:          same as filename without .py
        name:            log name
        pathname:        full path of the filename
        process:         pid of running process
        processName:     Process name same as MainProcess
        thread:          thread ID
        threadName:      Thread name
    """

    def get_console_handler(fmt):
        ch = logging.StreamHandler()
        console_format = logging.Formatter(fmt, style='{')
        console_format.default_msec_format = '%s.%03d'
        ch.setFormatter(console_format)
        ch.setLevel(logging.DEBUG)
        return ch

    log.debug('1.Default Format')

    fmt = f"{'{asctime:<24}'}|{'{levelname:^10}'}|{radio:^12}|{'{name:^14}'}|{' {message}'}"
    log.addHandler(get_console_handler(fmt))

    fmt = f"{'relativeCreated={relativeCreated:<24}'}"
    log.addHandler(get_console_handler(fmt))
    log.debug('2.This is a debug')

    from time import sleep
    sleep(1)

    fmt = f"{'thread={thread:<24}'}"
    log.addHandler(get_console_handler(fmt))
    log.info('3.This is an info')

    sleep(2)
    fmt = f"{'threadName={threadName:<24}'}"
    log.addHandler(get_console_handler(fmt))
    log.info('4.This is an info')
    # log.warning('5.This is a warning')
    # log.warning('6.This is a warning')
    # log.error('7.This is an error')
    # log.error('8.This is an error')
    # log.critical('9.This is a critical')
    # log.critical('10.This is a critical')
    # log.debug('11.This is a debug')
    # log.info('12.This is a info')

    # try:
    #     x = 1 / 0
    # except Exception:
    #     log.exception('12.This is an exception')


def logger_parts_tester(logs):
    r_log = logs['Reception']
    t_log = logs['Transmission']
    g_log = logs['Generator']
    c_log = logs['Core']

    t_log.debug('1.This is a debug')
    r_log.debug('1.This is a debug')
    t_log.info('2.This is an info')
    r_log.info('2.This is an info')
    t_log.warning('3.This is a warning')
    r_log.warning('3.This is a warning')
    t_log.error('4.This is an error')
    r_log.error('4.This is an error')
    t_log.critical('5.This is a critical')
    r_log.critical('5.This is a critical')
    c_log.debug('6.This is a debug')
    c_log.info('6.This is a info')

    try:
        x = 1 / 0
    except Exception:
        g_log.exception('6.This is an exception')

    from time import sleep

    sleep(1)
    print('---------- File Content ----------')

    with open(f'export/BUZ_RX_V1M.log', 'r') as f:
        print(f.read())


if __name__ == '__main__':
    # t_log = get_configured_logger('BUZ_RX_V1M', 'Transmission', file_level=logging.INFO,
    #                               console_level=logging.WARNING)
    # r_log = get_configured_logger('BUZ_RX_V1M', 'Reception', file_level=logging.INFO, console_level=logging.WARNING)

    logs = get_default_loggers('BUZ_RX_V1M')
    # test_logger_parts(logs)
    log_format_tester(logs['Core'], 'BUZ_RX_V1M')
