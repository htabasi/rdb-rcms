background = '#1c1a27'
# background = '#170000'

border_color = {'outside': {'fg': '#EBD3F8', 'bg': background},# '#272822'},
                'inside': {'fg': '#EBD3F8', 'bg': background }}# '#272822'}}

COLORS = {
    # 'background': '#272822',
    'background': background,
    'same_bg_column': False,
    'bg_column_deep': True,
    'bg_station_column': True,
    'free_same_as_station': True,
    'station_name': {'code': {'fg': '#F29F58', 'bg': '#1c1a27'},
                     'name': {'fg': '#F29F58', 'bg': '#1c1a27'},
                     'dot': {'fg': '#AB4459', 'bg': '#1c1a27'},
                     'spacer': border_color['inside']},
    'radio': {'led': {'default_left': '#bfc3ff', 'default_right': '#02864a'},
              'spacer': border_color['inside']},
    'title': {'station_title': {'name': {'fg': '#F29F58', 'bg': '#1c1a27'},
                                'spacer': border_color['inside']},
              'frequency_title': {'name': {'fg': '#F29F58', 'bg': '#1c1a27'},
                                  'spacer': border_color['inside']},
              'free_title': {'name': {'fg': 'yellow', 'bg': '#1c1a27'},
                             'spacer': border_color['inside']},
              'radio_title': {'txm': {'fg': '#F29F58', 'bg': '#1c1a27'},
                              'txs': {'fg': '#F29F58', 'bg': '#1c1a27'},
                              'rxm': {'fg': '#F29F58', 'bg': '#1c1a27'},
                              'rxs': {'fg': '#F29F58', 'bg': '#1c1a27'},
                              'spacer': {'fg': '#EBD3F8', 'bg': '#1c1a27'}},
              'main_title': {'main': {'fg': '#F29F58', 'bg': '#1c1a27'},
                             'sub': {'fg': '#AB4459', 'bg': '#1c1a27'},
                             'comment': {'fg': '#AB4459', 'bg': '#1c1a27'},
                             'spacer': border_color['inside']}
              },
    'lines': {'top': {'line': border_color['outside'],
                      'spacer': border_color['outside']},
              'second': {'line': border_color['inside'],
                         'spacer': border_color['outside']},
              'third': {'line': border_color['inside'],
                        'spacer': border_color['inside'],
                        'border': border_color['outside']},
              'inside': {'line': border_color['inside'],
                         'spacer': border_color['inside'],
                         'border': border_color['outside']},
              'bottom': {'line': border_color['inside'],
                         'spacer': border_color['inside'],
                         'border': border_color['outside']},
              },


}

Defined  = 1
Created = 2
Running = 3
Failed = 4
Stopping = 5
Stopped = 6

OK, WARN, ERROR = 1, 2, 3

LED = {
    'left' : {Defined: '#bfc3ff', Created: '#573cfa', Running: '#02864a',
              Failed: '#e8083e', Stopping: '#fb8d1a', Stopped: '#1c1a27'},
    'right' : {OK: '#02864a', WARN: '#fb8d1a', ERROR: '#e8083e'}
}

BOARDERS = {
    'top': "═",
    'bottom': "═",
    'left': "║",
    'right': "║",
    'top_left': "╔",
    'top_right' : "╗",
    'bottom_left' : "╚",
    'bottom_right' : "╝",

    'top_dual' : "╦",
    'bottom_dual' : "╩",
    'left_dual' : "╠",
    'right_dual' : "╣",

    'top_single' : "╤",
    'bottom_single' : "╧",
    'left_single' : "╟",
    'right_single' : "╢",

    'cross_dual_dual': "╬",
    'cross_dual_single': "╪",
    'cross_single_dual': "╫",
    'cross_single_single': "┼",

    'horizontal_dual': '═',
    'horizontal_single' : "─",
    'vertical_dual' : "║",
    'vertical_single' : "│",

}

SPACERS = {
    'station_name': '║',
    'station_title': '║',
    'free_title': '║',
    'frequency_title': '║',
    'radio': {'inside': '│', 'last': '║'},
    'main': '║',

}

radio_column, station_column = 8, 12
WIDTH = {
    'radio_column': radio_column,
    'station_column': station_column,
    'frequency_column': 4 * radio_column,
    'panel_column': 12 * radio_column + station_column,
}
