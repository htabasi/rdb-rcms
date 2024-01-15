import tkinter as tk
from tkinter import ttk
from tkinter.colorchooser import askcolor
from math import floor
import numpy as np
from numpy.random import normal
from threading import Thread
from time import time, sleep
from enum import Enum

# from time import sleep
# from threading import Thread


Graph_Background = '#303030'
Border_Color = 'orange'
Axis_Color = '#80a050'
Grid_Color = '#505030'
Horizontal_Graph_Space_Ratio = 0.9
Left_Right_Space_Ratio = 1
Vertical_Graph_Space_Ratio = 0.9
Top_Bottom_Space_Ratio = 1
Border_Thickness = 3
Graph_Shape_Types = ['Square', 'Line', 'Bar']
RXSeriesName = {}
SQ_LEVEL_TRANSLATOR = {
    'RXM': {0: -30, 1: -10},
    'RXS': {0: -60, 1: -40}
}
SQ_LEVEL_REVERSE_TRANSLATOR = {
    'RXM': {-30: 0, -10: 1},
    'RXS': {-60: 0, -40: 1}
}

Title_Button_Colors = {
    0:
        {
            'graph': '#61bb49',
            'button': '#61bb49',
            'border': '#2e7026',
            'text': 'white',
            'highlight': '#b1d89f'
        },
    1:
        {
            'graph': '#8ec641',
            'button': '#8ec641',
            'border': '#4e741f',
            'text': 'white',
            'highlight': '#c5de9c'
        },
    2:
        {
            'graph': '#b3d133',
            'button': '#b3d133',
            'border': '#647d18',
            'text': 'white',
            'highlight': '#7de29d'
        },
    3:
        {
            'graph': '#d9de20',
            'button': '#d9de20',
            'border': '#7a830e',
            'text': 'white',
            'highlight': '#e8ed9b'
        },
    4:
        {
            'graph': '#ffd504',
            'button': '#ffd504',
            'border': '#967c01',
            'text': 'white',
            'highlight': '#fee895'
        },
    5:
        {
            'graph': '#fec60d',
            'button': '#fec60d',
            'border': '#937302',
            'text': 'white',
            'highlight': '#ffdf92'
        },
    6:
        {
            'graph': '#feb914',
            'button': '#feb914',
            'border': '#946b01',
            'text': 'white',
            'highlight': '#ffd992'
        },
    7:
        {
            'graph': '#f9a61a',
            'button': '#f9a61a',
            'border': '#926001',
            'text': 'white',
            'highlight': '#ffcf8d'
        },
    8:
        {
            'graph': '#f7941d',
            'button': '#f7941d',
            'border': '#8f5501',
            'text': 'white',
            'highlight': '#fec689'
        },
    9:
        {
            'graph': '#f68122',
            # 'graph': '#7b4011',
            'button': '#f68122',
            'border': '#8e4a03',
            'text': 'white',
            'highlight': '#fbbc87'
        },
    10:
        {
            'graph': '#f46f22',
            'button': '#f46f22',
            'border': '#8e3705',
            'text': 'white',
            'highlight': '#fcb484'
        },
    11:
        {
            'graph': '#f24e32',
            'button': '#f24e32',
            'border': '#8e2811',
            'text': 'white',
            'highlight': '#f9a686'
        },
    12:
        {
            'graph': '#ed1b36',
            'button': '#ed1b36',
            'border': '#8b0013',
            'text': 'white',
            'highlight': '#f79882'
        },
    13:
        {
            'graph': '#d11e60',
            'button': '#d11e60',
            'border': '#7c0036',
            'text': 'white',
            'highlight': '#e694a2'
        },
    14:
        {
            'graph': '#a6247e',
            'button': '#a6247e',
            'border': '#610047',
            'text': 'white',
            'highlight': '#c88fb2'
        },
    15:
        {
            'graph': '#792c92',
            'button': '#792c92',
            'border': '#460154',
            'text': 'white',
            'highlight': '#af88bf'
        },
    16:
        {
            'graph': '#5c2d93',
            'button': '#5c2d93',
            'border': '#350456',
            'text': 'white',
            'highlight': '#9e85bf'
        },
    17:
        {
            'graph': '#483b97',
            'button': '#483b97',
            'border': '#28145c',
            'text': 'white',
            'highlight': '#948ac6'
        },
    18:
        {
            'graph': '#2c479e',
            'button': '#2c479e',
            'border': '#12205f',
            'text': 'white',
            'highlight': '#8d8fc8'
        },
    19:
        {
            'graph': '#115cad',
            'button': '#115cad',
            'border': '#083167',
            'text': 'white',
            'highlight': '#8a9ace'
        },
    20:
        {
            'graph': '#0171bb',
            'button': '#0171bb',
            'border': '#024272',
            'text': 'white',
            'highlight': '#7ea7dd'
        },
    21:
        {
            'graph': '#0088ba',
            'button': '#0088ba',
            'border': '#025170',
            'text': 'white',
            'highlight': '#7cb7d7'
        },
    22:
        {
            'graph': '#009da0',
            'button': '#009da0',
            'border': '#015f5f',
            'text': 'white',
            'highlight': '#7dc4ca'
        },
    23:
        {
            'graph': '#08b073',
            'button': '#08b073',
            'border': '#006a44',
            'text': 'white',
            'highlight': '#95d0b2'
        },
}
TIME_SHIFT = time()


class TextEnum(Enum):
    @staticmethod
    def text(item):
        s = str(item)
        if '.' not in s:
            return ''
        else:
            return s[s.index('.') + 1:]


class Series(TextEnum):
    RSSI = 1
    Noise_Max = 2
    Noise_Min = 3
    Noise_Mean = 4
    Noise_Median = 5
    Noise_Variance = 6
    Noise_Peak = 7
    Real_SQ = 8
    SNR_SQ = 9
    RSSI_SQ = 10
    Analytical_SQ = 11

    @staticmethod
    def order():
        return [Series.Analytical_SQ, Series.Noise_Max, Series.Noise_Min, Series.Noise_Variance, Series.Noise_Mean,
                Series.Noise_Median, Series.Noise_Peak, Series.SNR_SQ, Series.RSSI_SQ, Series.Real_SQ, Series.RSSI]


class SeriesShape(TextEnum):
    Square = 0
    Line = 1
    Bar = 2


class GraphSpecificationInterface(tk.Toplevel):
    def __init__(self, parent_button, **kw):
        super().__init__(parent_button.parent, **kw)
        self.title(parent_button.text)
        self.lift()
        self.colors = [parent_button.colors]
        self.protocol('WM_DELETE_WINDOW', self.on_close)
        self.finish_function = parent_button.update_button_color

        self.graph_color = self.create_color_row('Graph Color', 0, 'graph')
        self.btn_color = self.create_color_row('Button Color', 1, 'button')
        self.btn_border = self.create_color_row('Border Color', 2, 'border')
        self.btn_text_color = self.create_color_row('Button Text Color', 3, 'text')
        self.highlight_color = self.create_color_row('Highlight Color', 4, 'highlight')

        self.graph_shape = self.create_radio_row('Graph Shape', 5)
        self.graph_shape.set(SeriesShape.text(parent_button.series_shape))
        self.shape_text_convert = {SeriesShape.text(shape): shape for shape in SeriesShape}
        self.labels = {
            'graph': self.graph_color,
            'button': self.btn_color,
            'border': self.btn_border,
            'text': self.btn_text_color,
            'highlight': self.highlight_color
        }
        self.ok_btn = ttk.Button(self, text='OK', width=15, command=self.on_close)
        self.ok_btn.grid(row=6, column=0, columnspan=2)

        self.graph_shape.trace('w', lambda *args: self.update_shape(parent_button))

    def create_color_row(self, text, row, part):
        ttk.Label(self, text=text, justify=tk.LEFT, width=30).grid(row=row, column=0)
        lbl = ttk.Label(self, text='   ', relief=tk.RAISED, width=5, background=self.colors[0][part])
        lbl.grid(row=row, column=1)
        lbl.bind('<Button-1>', lambda e: self.choose_color(part))
        return lbl

    def create_radio_row(self, text, row):
        shape_var = tk.StringVar()
        ttk.Label(self, text=text, justify=tk.LEFT, width=30).grid(row=row, column=0)
        for i, shape_name in enumerate(SeriesShape):
            txt = SeriesShape.text(shape_name)
            g_sh_rb = ttk.Radiobutton(self, text=txt, variable=shape_var, value=txt)
            g_sh_rb.grid(row=row, column=i + 1)
        return shape_var

    def choose_color(self, part):
        new_color = askcolor(self.colors[0][part])[1]
        if new_color is None:
            return
        self.colors[0][part] = new_color
        print(part, ':', self.colors[0][part])
        self.labels[part].config(background=self.colors[0][part])
        self.lift()

    def update_shape(self, button):
        button.series_shape = self.shape_text_convert.get(self.graph_shape.get())
        if button.update_series_shape is not None:
            button.update_series_shape(button.series_shape)

    def on_close(self):
        self.destroy()
        self.finish_function()


class SeriesButton:
    def __init__(self, parent, corners, colors: dict = None, text='RXM', head='', func=None, pos=(0, 0),
                 titles_count=1, boss_click=None, boss_double_click=None, update_series_shape=None):
        self.parent = parent
        x1, y1, x2, y2 = corners
        self.on_click_func = func
        self.tag = head + text
        self.text = text
        self.position = pos
        self.titles_count = titles_count
        self.border_tag = self.tag + 'border'
        self.btn_tag = self.tag + 'btn'
        self.text_tag = self.tag + 'text'
        if colors is None:
            self.colors = {
                'graph': 'yellow',
                'button': '#ff3030',
                'border': '#ff0000',
                'text': 'white',
                'highlight': 'yellow'
            }
        else:
            self.colors = colors
        self.enabled = True
        self.series_shape = SeriesShape.Square
        self.border_width = 3
        self.update_series_shape = update_series_shape
        text_point = (x1 + x2) // 2, (y1 + y2) // 2
        self.shapes = [
            self.round_rectangle(x1, y1, x2, y2, fill=self.colors['border'], tags=(self.tag, self.border_tag)),
            self.round_rectangle(x1 + self.border_width, y1 + self.border_width, x2 - self.border_width,
                                 y2 - self.border_width, fill=self.colors['button'], tags=(self.tag, self.btn_tag)),
            self.parent.create_text(*text_point, text=self.text, font=("Calibri", 9), fill=self.colors['text'],
                                    tags=(self.tag, self.text_tag))
        ]
        if boss_click is not None:
            self.parent.tag_bind(self.tag, "<Button-1>", lambda e: boss_click())
            self.parent.tag_bind(self.tag, "<Double-Button-1>", lambda e: boss_double_click())
        else:
            self.parent.tag_bind(self.tag, "<Button-1>", lambda e: self.on_clicked())
        self.parent.tag_bind(self.tag, "<Button-3>", lambda e: self.on_right_click())
        self.parent.tag_bind(self.tag, "<Enter>", lambda e: self.on_mouse_over())
        self.parent.tag_bind(self.tag, "<Leave>", lambda e: self.on_mouse_leave())

    def update_position(self, w):
        nw = w // self.titles_count
        row, i = self.position
        height = self.parent.top_space // 2
        x1, y1, x2, y2 = i * nw, row * height, (i + 1) * nw, (row + 1) * height
        text_point = (x1 + x2) // 2, (y1 + y2) // 2

        for obj in self.shapes:
            self.parent.delete(obj)
        self.shapes = [
            self.round_rectangle(x1, y1, x2, y2, fill=self.colors['border'], tags=(self.tag, self.border_tag)),
            self.round_rectangle(x1 + self.border_width, y1 + self.border_width, x2 - self.border_width,
                                 y2 - self.border_width, fill=self.colors['button'], tags=(self.tag, self.btn_tag)),
            self.parent.create_text(*text_point, text=self.text, font=("Calibri", 9), fill=self.colors['text'],
                                    tags=(self.tag, self.text_tag))
        ]

    def update_button_color(self):
        if self.enabled:
            self.parent.itemconfigure(self.border_tag, fill=self.colors['border'])
            self.parent.itemconfigure(self.btn_tag, fill=self.colors['button'])
            self.parent.itemconfigure(self.text_tag, fill=self.colors['text'])
        else:
            self.parent.itemconfigure(self.border_tag, fill=self.parent.graph_background)
            self.parent.itemconfigure(self.btn_tag, fill=self.parent.graph_background)
            self.parent.itemconfigure(self.text_tag, fill=self.colors['text'])

    def on_clicked(self):
        # print(self.colors)
        if self.on_click_func is not None:
            self.on_click_func()
        # print(self.tag, self.enabled)
        if self.enabled:
            # self.parent.itemconfigure(self.border_tag, fill=self.parent.graph_background)
            self.parent.itemconfigure(self.btn_tag, fill=self.parent.graph_background)
            self.enabled = False
        else:
            # self.parent.itemconfigure(self.border_tag, fill=self.colors['highlight'])
            self.parent.itemconfigure(self.btn_tag, fill=self.colors['button'])
            self.enabled = True

    def on_right_click(self):
        GraphSpecificationInterface(self)

    def on_mouse_over(self):
        self.parent.itemconfigure(self.border_tag, fill=self.colors['highlight'])
        self.parent.mouse_on_button = self.text

    def on_mouse_leave(self):
        self.parent.itemconfigure(self.border_tag, fill=self.colors['border'])
        self.parent.mouse_on_button = None

    def round_rectangle(self, x1, y1, x2, y2, radius=25, **kwargs):
        points = [x1 + radius, y1,
                  x1 + radius, y1,
                  x2 - radius, y1,
                  x2 - radius, y1,
                  x2, y1,
                  x2, y1 + radius,
                  x2, y1 + radius,
                  x2, y2 - radius,
                  x2, y2 - radius,
                  x2, y2,
                  x2 - radius, y2,
                  x2 - radius, y2,
                  x1 + radius, y2,
                  x1 + radius, y2,
                  x1, y2,
                  x1, y2 - radius,
                  x1, y2 - radius,
                  x1, y1 + radius,
                  x1, y1 + radius,
                  x1, y1]

        return self.parent.create_polygon(points, **kwargs, smooth=True)

    def clear(self):
        for obj in self.shapes:
            self.parent.delete(obj)


class Graph(tk.Canvas):
    def __init__(self, parent, **kwargs):
        super(Graph, self).__init__(parent, background=Graph_Background, **kwargs)
        self.W, self.H, self.GW, self.GH = 0, 0, 0, 0
        self.CW, self.CH = 0, 0
        self.right_space, self.left_space, self.top_space, self.bottom_space = 0, 0, 0, 0
        self.hsr, self.lrr = Horizontal_Graph_Space_Ratio, Left_Right_Space_Ratio
        self.vsr, self.tbr = Vertical_Graph_Space_Ratio, Top_Bottom_Space_Ratio
        self.left, self.right = -10, 10
        self.bottom, self.top = -10, 10
        self.w, self.h = self.right - self.left, self.top - self.bottom
        self.mx, self.my, self.dx, self.dy = 0, 0, 0, 0
        self.mw, self.mh, self.dw, self.dh = 0, 0, 0, 0
        self.mouse_on_button = None
        self.zero_time, self.is_first = 0, True

        self.series = {}

        self.raw_points = {}
        self.lines, self.labels, self.graph, self.upper_buttons, self.lower_buttons = [], [], [], [], []
        self.horizontal_top_grid_values, self.horizontal_bottom_grid_values = [], []
        self.vertical_left_grid_values, self.vertical_right_grid_values = [], []
        self.horizontal_top_grid_labels, self.horizontal_bottom_grid_labels = [], []
        self.vertical_left_grid_labels, self.vertical_right_grid_labels = [], []
        self.main_titles, self.standby_titles = [], []
        self.graph_names = []
        self.button_colors, self.mapper, self.series_buttons = {}, {}, {}

        self.graph_background = Graph_Background
        self.axis_color = Axis_Color
        self.grid_color = Grid_Color
        self.border_color = Border_Color
        self.border_thickness = Border_Thickness

        self.hint_position = tk.Toplevel(bg='yellow')
        self.hint_position.overrideredirect(True)
        self.hint_position.geometry('0x0+0+0')
        self.position_lbl = ttk.Label(self.hint_position, background='yellow', foreground='blue')
        self.position_lbl.pack()
        self.bind('<Motion>', self.show_hint)
        self.bind('<Leave>', lambda e: self.hint_position.geometry('0x0+0+0'))
        self.first_titles, self.second_titles = [], []

    def add_to_series(self, x, y, series: Series, rx: str):
        pass

    @staticmethod
    def remove_dead_points(points: list, min_acceptable, log=False):
        min_acceptable += 0.3
        if log:
            print('=' * 30)
            print('points = ')
            for i, p in enumerate(points):
                print(f"{i} : {p}")
            print('-' * 30)

        for i, point in enumerate(points):
            try:
                next_point = points[i + 1]
            except IndexError:
                return

            if log:
                print(f"{i} : {point} next point: {next_point} min_acceptable = {min_acceptable}")
                print('-' * 30)
                print(f"conditions 1: point[0] < min_acceptable      = {point[0] < min_acceptable}")
                print(f"conditions 2: next_point[0] > min_acceptable = {next_point[0] > min_acceptable}")
                print(f"result condition = {point[0] < min_acceptable < next_point[0]}")
                print(f"result condition 2:  {point[0] < min_acceptable and next_point[0] < min_acceptable}")
                print('-' * 30)

            if point[0] < min_acceptable < next_point[0]:
                if log:
                    print(f'points[0] will change to {(min_acceptable, point[1])}')
                points[0] = (min_acceptable, point[1])
                return
            elif point[0] < min_acceptable and next_point[0] < min_acceptable:
                if log:
                    print('points[0] will be removed')
                points.pop(0)

        print('-' * 30)
        for i, p in enumerate(points):
            print(f"{i} : {p}")
        print('=' * 30)

    def add_raw_points(self, raw_points, x, y):
        raw_points.append((x, y))
        self.remove_dead_points(raw_points, min_acceptable=x - self.w)

    def add_square_series(self, eval_points, x, y):
        if len(eval_points) == 0:
            eval_points.append((x, y))
        else:
            lx, ly = eval_points[-1]
            eval_points.append((x, ly))
            eval_points.append((x, y))
            self.remove_dead_points(eval_points, min_acceptable=x - self.w)

    def update_graph(self):
        self.clear_graph()

        for key in self.graph_names:
            if len(self.raw_points.get(key)) < 2:
                continue
            points = [self.convert(*point) for point in self.raw_points.get(key)]
            self.graph.append(self.create_line(points, fill=self.series_buttons[key].colors['graph']))

    def update_dimension(self, e):
        # new_width, new_height = self.get_new_dimension()
        new_width, new_height = self.winfo_width(), self.winfo_height()
        # print(new_width != self.winfo_width(), new_height != self.winfo_height())
        if self.W != new_width or self.H != new_height:
            self.W, self.H = e.width, e.height

            self.GW, self.GH = int(self.W * self.hsr), int(self.H * self.vsr)
            self.right_space = int(self.W * (1 - self.hsr) / (1 + self.lrr))
            self.left_space = int(self.right_space * self.lrr)
            self.bottom_space = int(self.H * (1 - self.vsr) / (1 + self.tbr))
            self.top_space = int(self.bottom_space * self.tbr)

            self.update_conversion()
            self.clear_lines()
            self.clear_labels()
            self.clear_graph()

            # Grid Creation
            self.grid_creation(_min=self.left, _max=self.right, grid_start=self.top, grid_end=self.bottom,
                               label_pos=self.bottom, offset=1)
            self.grid_creation(_min=self.bottom, _max=self.top, grid_start=self.left, grid_end=self.right,
                               label_pos=self.left, offset=-1, vertical=True)
            self.update_title_button()
            self.other_grid_creation()

            # Axis Drawing
            if self.bottom <= 0 <= self.top:
                self.create_and_save_line([self.convert(self.left, 0), self.convert(self.right, 0)],
                                          color=self.axis_color, thickness=2)
            if self.left <= 0 <= self.right:
                self.create_and_save_line([self.convert(0, self.top), self.convert(0, self.bottom)],
                                          color=self.axis_color, thickness=2)

            self.create_and_save_line([(self.left_space, self.top_space),
                                       (self.left_space + self.GW, self.top_space),
                                       (self.left_space + self.GW, self.top_space + self.GH),
                                       (self.left_space, self.top_space + self.GH),
                                       (self.left_space, self.top_space)],
                                      color=self.border_color, thickness=self.border_thickness)
            self.update_graph()

    def update_title_button(self):
        if len(self.upper_buttons) != 0:
            for btn in self.upper_buttons + self.lower_buttons:
                btn.update_position(self.W)
        else:
            self.create_title_button(0, self.top_space // 2, head='RXM', row=0)
            self.create_title_button(self.top_space // 2, self.top_space // 2, head='RXS', row=1, upper=False)

    def create_title_button(self, top, height, head, row, upper=True):
        titles_count = 1 + len(Series)
        w = self.W // titles_count
        if upper:
            buttons = self.upper_buttons
            first_color_index = 0
        else:
            buttons = self.lower_buttons
            first_color_index = 12

        # Creating Master Buttons
        buttons.append(SeriesButton(self, (0, top, w, top + height), text=head, head=head, pos=(row, 0),
                                    titles_count=titles_count, colors=Title_Button_Colors[first_color_index],
                                    boss_click=lambda: self.global_click(buttons),
                                    boss_double_click=lambda: self.global_double_click(buttons)))
        if head not in self.series_buttons:
            self.series_buttons[head] = {}
        # Creating Slave Buttons
        for i, series in enumerate(Series):
            title_text = Series.text(series)
            btn = SeriesButton(self, ((i + 1) * w, top, (i + 2) * w, top + height), text=title_text, head=head,
                               pos=(row, i + 1), titles_count=titles_count,
                               colors=Title_Button_Colors[first_color_index + i + 1],
                               update_series_shape=lambda shape, rx=head, s=series: self.rebuild_eval_points(rx, s,
                                                                                                             shape))
            buttons.append(btn)
            self.series_buttons[head][series] = btn

        # for i, title in enumerate(titles):
        #     if i == 0:
        #         buttons.append(SeriesButton(self, (i * w, top, (i + 1) * w, top + height), text=title, head=head,
        #                                     pos=(row, i), titles_count=len(titles), colors=colors[title],
        #                                     boss_click=lambda: self.global_click(buttons),
        #                                     boss_double_click=lambda: self.global_double_click(buttons)))
        #         self.series_buttons[title] = buttons[-1]
        #     else:
        #         buttons.append(SeriesButton(self, (i * w, top, (i + 1) * w, top + height), text=title, head=head,
        #                                     pos=(row, i), titles_count=len(titles), colors=colors[title]))
        #         self.series_buttons[title] = buttons[-1]

    @staticmethod
    def global_click(buttons):
        for btn in buttons:
            btn.on_clicked()

    @staticmethod
    def global_double_click(buttons):
        stat = buttons[0].enabled
        for btn in buttons:
            if btn.enabled == stat:
                btn.on_clicked()

    def other_grid_creation(self):
        pass

    def grid_creation(self, _min, _max, grid_start, grid_end, label_pos, offset, vertical=False):
        values = self.get_distance(_min, _max)
        if vertical:
            for v in values:
                self.create_and_save_line([self.convert(grid_start, v), self.convert(grid_end, v)],
                                          color=self.grid_color)
                self.create_and_save_window(self.convert(label_pos, v), v, h=offset)
        else:
            for v in values:
                self.create_and_save_line([self.convert(v, grid_start), self.convert(v, grid_end)],
                                          color=self.grid_color)
                self.create_and_save_window(self.convert(v, label_pos), v, v=offset)

    def create_and_save_line(self, points, color='white', thickness=1):
        self.lines.append(self.create_line(points, fill=color, width=thickness))

    def create_and_save_window(self, point, value, h=0, v=0):
        h_shift = {0: 0, 1: self.right_space // 2, -1: -self.left_space // 2}.get(h)
        v_shift = {0: 0, 1: self.bottom_space // 2, -1: -self.top_space // 2}.get(v)
        self.labels.append(self.create_text(point[0] + h_shift, point[1] + v_shift, text=f'{value:5.4}', fill='yellow'))

    def update_conversion(self):
        self.mx = self.GW / (self.right - self.left)
        self.my = self.GH / (self.bottom - self.top)

        self.dx = self.left_space - self.mx * self.left
        self.dy = self.top_space - self.my * self.top

        self.mw = (self.right - self.left) / self.GW
        self.mh = (self.bottom - self.top) / self.GH

        self.dw = self.left - self.mw * self.left_space
        self.dh = self.top - self.mh * self.top_space

    def convert(self, x, y):
        return int(self.mx * x + self.dx), int(self.my * y + self.dy)

    def convert_rect(self, x1, y1, x2, y2):
        return (*self.convert(x1, y1), *self.convert(x2, y2))

    def invert_convert(self, xp, yp):
        return self.mw * xp + self.dw, self.mh * yp + self.dh

    def show_hint(self, e):
        self.hint_position.geometry(f'100x20+{e.x_root + 10}+{e.y_root + 20}')
        self.hint_position.lift()
        if self.mouse_on_button is None:
            self.position_lbl.config(text='{:6.4},{:5.4}'.format(*self.invert_convert(e.x, e.y)))
        else:
            self.position_lbl.config(text=self.mouse_on_button)

    def clear_lines(self):
        for line in self.lines:
            self.delete(line)

    def clear_labels(self):
        for window in self.labels:
            self.delete(window)

    def clear_graph(self):
        for line in self.graph:
            self.delete(line)
        # self.graph = []

    @staticmethod
    def get_distance(p, q):
        """"
        input : left & right same as -120, 10
        output : list of grid points same as:
        [-120, -110, -100, -90, -80, -70, -60, -50, -40, -30, -20, -10, 0, 10]
        """
        floating_digit = 2
        if q < p:
            p, q = q, p
        m = q - p
        power = floor(np.log10(m)) - 1
        distances = [i * 10 ** power for i in (1, 2, 4, 5)]
        best_distances = [i for i in distances if 10 <= m / i <= 20]
        selected_distance = best_distances[0]
        fd = 10 ** floating_digit

        rounded_start = (p // selected_distance) * selected_distance
        output, i, steps = [], 0, rounded_start
        while steps <= q:
            steps = np.round(fd * (rounded_start + i * selected_distance)) / fd
            i += 1
            if p <= steps <= q:
                output.append(steps)

        return output

    def get_square_points(self, raw_points, now):
        t0, r0 = raw_points[0]
        points = [self.convert(t0 - now, r0)]
        pre_r = points[0][1]
        for t, r in raw_points[1:-1]:
            new_point = self.convert(t - now, r)
            points.append((new_point[0], pre_r))
            points.append(new_point)
            pre_r = new_point[1]
        lp = raw_points[-1]
        new_point = self.convert(lp[0] - now, lp[1])
        points.append(new_point)
        return points

    def rebuild_eval_points(self, rx, series, shape):
        raw_points = self.series[rx][series]['raw']
        if shape == SeriesShape.Square:
            evp = [raw_points[0]]
            for p in raw_points[1:]:
                if p[1] == evp[-1][1]:
                    continue
                evp.append((p[0], evp[-1][1]))
                evp.append(p)
        elif shape == SeriesShape.Line:
            evp = raw_points
        else:
            evp = raw_points
        self.series[rx][series]['eval'] = evp

    def get_converted_points(self, points, now):
        return [self.convert(point[0] - now, point[1]) for point in points]

    def get_converted_bars(self, bars, now):
        return [tuple((*self.convert(bar[0] - now, bar[1]), *self.convert(bar[2] - now, bar[3]))) for bar in bars]

    @staticmethod
    def remove_unneeded_points(points):
        result = [points[0]]
        for i, p in enumerate(points[1:-1]):
            if points[i][1] == p[1] == points[i + 2][1]:
                continue
            else:
                result.append(p)
        result.append(points[-1])
        return result

    @staticmethod
    def add_points(points):
        result = [points[0]]
        yp = result[0][1]
        for p in points[1:-1]:
            if p[1] == yp:
                continue
            elif p[1] > yp:
                result.append((p[0], yp))
            result.append(p)
            yp = p[1]
        result.append(points[-1])
        return result

    @staticmethod
    def rectangle_points(points):
        result = []
        p0 = points[0]
        for p in points[1:]:
            if p[1] - p0[1] <= 0:
                result.append((*p0, *p))
            p0 = p
        return result


class RSSIGraph(Graph):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.left, self.right = -300, 0
        self.bottom, self.top = -120, 10
        self.w, self.h = self.right - self.left, self.top - self.bottom
        self.noise = {}
        self.rssi_array = []

        self.vsr, self.tbr = 0.85, 2
        self.evaluated_points = {}

    def add_to_series(self, x, y, series: Series, rx: str):
        if rx not in self.series:
            self.series[rx] = {}
        if series not in self.series[rx]:
            self.series[rx][series] = {}
        if 'raw' not in self.series[rx][series]:
            self.series[rx][series]['raw'] = []
            self.series[rx][series]['eval'] = []
            self.series[rx][series]['bar'] = []

        if series == Series.RSSI_SQ:
            self.series[rx][series]['eval'] = [(self.left, y), (self.right, y)]
        elif series == Series.RSSI:
            self.add_raw_points(self.series[rx][series]['raw'], x, y)
            self.rssi_array.append(y)

            if self.series_buttons[rx][series].series_shape == SeriesShape.Square:
                self.add_square_series(self.series[rx][series]['eval'], x, y)
            elif self.series_buttons[rx][series].series_shape == SeriesShape.Line:
                self.series[rx][series]['eval'].append((x, y))
                self.remove_dead_points(self.series[rx][series]['eval'], min_acceptable=x - self.w)
            elif self.series_buttons[rx][series].series_shape == SeriesShape.Bar:
                bw = 0.2
                x1, x2 = x + bw / 2, x - bw / 2
                self.series[rx][series]['bar'].append((x1, y, x2, self.bottom))
                self.remove_dead_points(self.series[rx][series]['bar'], min_acceptable=x - self.w)
            try:
                if rx not in self.noise:
                    self.noise[rx] = []
                if not SQ_LEVEL_REVERSE_TRANSLATOR[rx].get(self.series[rx][Series.Real_SQ]['raw'][-1][1]):
                    print(f'---------noise adding on : {(x,y)}')
                    self.noise[rx].append((x, y))
            except KeyError:
                pass

            last_x = self.series[rx][series]['eval'][-1][0]
            try:
                last_y = self.series[rx][Series.Real_SQ]['eval'][-1][1]
            except (KeyError, IndexError):
                pass
            else:
                eval_points = self.series[rx][Series.Real_SQ]['eval']
                if len(eval_points) == 1 or eval_points[-1][1] != eval_points[-2][1]:
                    eval_points.append((last_x, last_y))
                else:
                    eval_points[-1] = (last_x, last_y)
                self.remove_dead_points(self.series[rx][Series.Real_SQ]['eval'], min_acceptable=x - self.w)

        elif series == Series.Real_SQ:
            cy = SQ_LEVEL_TRANSLATOR[rx][y]
            self.add_raw_points(self.series[rx][series]['raw'], x, cy)
            self.series[rx][series]['eval'].append((x, cy))
            self.remove_dead_points(self.series[rx][series]['eval'], min_acceptable=x - self.w)
            # self.add_square_series(self.series[rx][series]['eval'], x, cy)

        # Simply print RSSI List
        # t = time()
        # print(f'{Series.RSSI} @ {rx} : ', len(self.series[rx][Series.RSSI]), end='')
        # for point in self.series[rx][Series.RSSI]:
        #     print(f'({point[0]-t:^2.3}, {point[1]}), ', end='')
        # print()

    def other_grid_creation(self):
        values = self.get_distance(self.bottom, self.top)
        for v in values:
            self.create_and_save_window(self.convert(self.right, v), self.rssi(dbm=v), h=1)

    def update_graph(self):
        self.calculate_parameters()
        self.clear_graph()
        for rx in self.series:
            # print("="*30)
            for series_name in Series.order():
                # print(f"{series_name:20} Enabel:{self.series_buttons[rx][series_name].enabled} {series_name in self.series[rx]}")
                # print(f"Result: {not self.series_buttons[rx][series_name].enabled or series_name not in self.series[rx]}")
                # print("-" * 30)
                if not self.series_buttons[rx][series_name].enabled or series_name not in self.series[rx]:
                    continue
                now = time() - TIME_SHIFT
                color = self.series_buttons[rx][series_name].colors['graph']
                eval_points = self.series[rx][series_name]['eval']

                if series_name in [Series.RSSI, Series.Real_SQ, Series.RSSI_SQ, Series.Noise_Max, Series.Noise_Min,
                                   Series.Noise_Mean, Series.Noise_Median, Series.Noise_Variance]:
                    # print(series_name)
                    if self.series_buttons[rx][series_name].series_shape != SeriesShape.Bar:
                        if len(eval_points) < 2:
                            continue
                        if series_name in [Series.RSSI_SQ, Series.Noise_Max, Series.Noise_Min, Series.Noise_Mean,
                                           Series.Noise_Median, Series.Noise_Variance]:
                            shift_time = 0
                        else:
                            shift_time = now
                        points = self.get_converted_points(eval_points, shift_time)
                        self.graph.append(self.create_line(points, fill=color, width=1))
                    else:
                        bars = self.get_converted_bars(self.series[rx][series_name]['bar'], now)
                        for bar in bars:
                            self.graph.append(self.create_rectangle(*bar, outline=color))

    @staticmethod
    def rssi(dbm=None, uv=None):
        if dbm is not None:
            return np.sqrt(5 * 10 ** (dbm / 10 + 10))
        elif uv is not None:
            return -106.98970004336019 + 20 * np.log10(uv)

    def calculate_parameters(self):

        for rx in self.noise:
            try:
                t, noise = zip(*self.noise[rx])
            except ValueError:
                pass
            else:
                if len(noise) > 2:
                    n_mean, n_var, noise = self.revise_data(noise)
                else:
                    n_mean = np.mean(noise)
                    n_var = np.sqrt(np.var(noise))
                n_max = np.max(noise)
                n_min = np.min(noise)
                n_median = np.median(noise)

                for series in [Series.Noise_Max, Series.Noise_Min, Series.Noise_Mean, Series.Noise_Median,
                               Series.Noise_Variance]:
                    if series not in self.series[rx]:
                        self.series[rx][series] = {}
                self.series[rx][Series.Noise_Max]['eval'] = [(self.left, n_max), (self.right, n_max)]
                self.series[rx][Series.Noise_Min]['eval'] = [(self.left, n_min), (self.right, n_min)]
                self.series[rx][Series.Noise_Median]['eval'] = [(self.left, n_median), (self.right, n_median)]
                self.series[rx][Series.Noise_Mean]['eval'] = [(self.left, n_mean), (self.right, n_mean)]
                self.series[rx][Series.Noise_Variance]['eval'] = [(self.left, n_mean + 2.33 * n_var),
                                                                  (self.right, n_mean + 2.33 * n_var)]

    @staticmethod
    def revise_data(data):
        def get_revise(data):
            mean, dev = np.mean(data), np.sqrt(np.var(data))
            accept_data, reject_data = [], []
            for v in data:
                if abs(v - mean) <= 3 * dev:
                    accept_data.append(v)
                else:
                    print(v)
                    reject_data.append(v)
            return mean, dev, accept_data, reject_data

        mean, deviation, result, other = get_revise(data)
        while True:
            previous_length = len(result)
            mean, deviation, result, new_other = get_revise(result)
            other.extend(new_other)
            if previous_length == len(result):
                break

        print(other)

        return mean, deviation, result


class NoiseGraph(Graph):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.left, self.right = -120, 10
        self.bottom, self.top = 0, 100
        self.vsr, self.tbr = 0.85, 2
        self.main_titles = ['RXM Noise', 'M-Noise Distribution', 'M-Noise Mean', 'M-Noise Median', 'M-Noise Variance']
        self.standby_titles = ['RXS Noise', 'S-Noise Distribution', 'S-Noise Mean', 'S-Noise Median',
                               'S-Noise Variance']

        # self.button_colors = self.get_title_colors(self.main_titles, self.standby_titles)


class ReceptionGraph(Graph):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.left, self.right = -90, 10
        self.bottom, self.top = 0, 30
        self.vsr, self.tbr = 0.85, 2
        self.main_titles = ['RXM Reception', 'M-Last 5 Min', 'M-Last 1 Hour', 'M-Last Day', 'M-Last Week',
                            'M-Last Month']
        self.standby_titles = ['RXS Reception', 'S-Last 5 Min', 'S-Last 1 Hour', 'S-Last Day', 'S-Last Week',
                               'S-Last Month']

        # self.button_colors = self.get_title_colors(self.main_titles, self.standby_titles)


class StatisticGraph(Graph):
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.left, self.right = -90, 10
        self.bottom, self.top = 0, 100
        self.vsr, self.tbr = 0.85, 2
        self.main_titles = ['RXM Noise Statistics', 'M-Last 5 Min', 'M-Last Hour', 'M-Last Day', 'M-Last Week',
                            'M-Last Month']
        self.standby_titles = ['RXS Noise Statistics', 'S-Last 5 Min', 'S-Last Hour', 'S-Last Day', 'S-Last Week',
                               'S-Last Month']

        # self.button_colors = self.get_title_colors(self.main_titles, self.standby_titles)


class RXSimulator(Thread):
    def __init__(self, graph, rx, speed):
        super().__init__(name=f'{rx} Simulator Thread', daemon=True)
        self.rssi = {'noise': [], 'pilot': [], 'controller': []}
        self.graph = graph
        self.rx = rx
        self.generator_interval = speed
        # self.sq_on = {'RXM': 0, 'RXS': -20}.get(rx)
        # self.sq_off = {'RXM': -10, 'RXS': -30}.get(rx)
        self.rssi_threshold = {'RXM': -90, 'RXS': -80}.get(rx)
        self.sq_off_offset = {'RXM': 3, 'RXS': 2}.get(rx)
        self.previous_sq = -1
        self.noise_mean, self.noise_sigma = -110, 4
        self.pilot_mean = -80

        self.noise = (self.noise_mean, self.noise_sigma)
        self.pilot = (self.pilot_mean, 30)
        self.pilot_noise = (0, 1)
        self.controller = (-10, 1)
        self.controller_noise = (0, 1)
        self.choice_time = (3, 2)
        self.choices = list(range(100))
        self.pilot_choice = list(range(15))
        self.controller_choice = list(range(15, 30))

    def run(self):
        from random import choice
        noise = iter(self.generator(*self.noise))
        pilot = iter(self.random_generator(-95, -55))
        # pilot = iter(self.generator(*self.pilot))
        pilot_noise = iter(self.generator(*self.pilot_noise))
        controller = iter(self.generator(*self.controller))
        controller_noise = iter(self.generator(*self.controller_noise))
        choice_time = iter(self.choice_length_generator(*self.choice_time))
        tcm, time_counter, c = 0, 1, 10
        pilot_base, controller_base = self.pilot[0], self.controller[0]
        self.graph.add_to_series(self.get_time(), self.rssi_threshold, Series.RSSI_SQ, self.rx)
        # simple_rssi = iter([-100, -70, -10, -110, -120])

        while True:
            if time_counter > tcm:
                c = choice(self.choices)
                tcm = next(choice_time)
                if c in self.pilot_choice:
                    s = 'pilot'
                    pilot_base = next(pilot)
                elif c in self.controller_choice:
                    s = 'controller'
                    controller_base = next(controller)
                else:
                    s = 'noise'

                # print(f"{tcm} second {s} selected")
                time_counter = 0

            if c in self.pilot_choice:
                new_rssi = pilot_base + next(pilot_noise)
                if new_rssi < self.noise_mean - 2.33 * self.noise_sigma:
                    new_rssi = int(new_rssi + 1.5 * (self.pilot_mean - new_rssi))
                self.rssi['pilot'].append(new_rssi)
            elif c in self.controller_choice:
                new_rssi = controller_base + next(controller_noise)
                self.rssi['controller'].append(new_rssi)
            else:
                new_rssi = next(noise)
                self.rssi['noise'].append(new_rssi)

            sq = int(new_rssi >= self.rssi_threshold - self.sq_off_offset * self.previous_sq)

            self.graph.add_to_series(self.get_time(), new_rssi, Series.RSSI, self.rx)
            if self.previous_sq != sq:
                # print(f'********* SQ Sending {sq}')
                self.graph.add_to_series(self.get_time(), sq, Series.Real_SQ, self.rx)
            self.previous_sq = sq

            sleep(self.generator_interval)
            time_counter += self.generator_interval

    @staticmethod
    def get_time(floating_digit=1):
        p = 10 ** floating_digit
        return int(p * (time() - TIME_SHIFT)) / p

    def generator(self, mu, sigma):
        sleep(1)
        while True:
            yield int(normal(mu, sigma))

    def random_generator(self, min_value, max_value):
        from random import choice
        sleep(1)
        data = range(min_value, max_value)
        while True:
            yield choice(data)

    def choice_length_generator(self, mu, sigma):
        sleep(1)
        while True:
            n = normal(mu, sigma)
            if n < 0.1:
                n = mu - n
            yield n

    def print_rssi(self):
        def get_next(key, i):
            try:
                return self.rssi[key][i]
            except IndexError:
                return '*'

        print(f"{'Noise':^10} | {'Controller':^10} | {'Pilot':^10}")
        print("-" * 30)
        for i in range(100):
            nr, cr, pr = get_next('noise', i), get_next('controller', i), get_next('pilot', i)
            print(f"{nr:^10} | {cr:^10} | {pr:^10}")
        print("-" * 30)
        print(f"{len(self.rssi['noise']):^10} | {len(self.rssi['controller']):^10} | {len(self.rssi['pilot']):^10}")


def f(x):
    y = 1
    for i in range(10):
        y = y * (x ** 2 - i ** 2)
    # y = x
    if y > 0:
        y = np.log(100 + y)
    elif y < 0:
        y = - np.log(- y + 100)

    # print(y)
    return y


def graph_updater(graphs, interval):
    sleep(2)
    i = 5
    calculate = False
    while True:
        for graph in graphs:
            graph.update_graph()
            # if calculate:
            #     graph.calculate_parameters()
        if calculate:
            i = 5
        sleep(interval)
        i -= 1
        calculate = i == 0


def generator(graph, start, end):
    points = 200
    step = (end - start) / points
    x = start
    while x <= end:
        graph.add_to_series(x, f(x))
        x += step
        # sleep(0.01)
    print('finish')


def add_points(points):
    result = [points[0]]
    yp = result[0][1]
    for p in points[1:-1]:
        if p[1] == yp:
            continue
        elif p[1] > yp:
            result.append((p[0], yp))
        result.append(p)
        yp = p[1]
    result.append(points[-1])
    return result


def rectangle_points(points):
    result = []
    p0 = points[0]
    for p in points[1:]:
        if p[1] - p0[1] <= 0:
            result.append((*p0, *p))
        p0 = p
    return result


def remove_unneeded_points(points):
    result = [points[0]]
    for i, p in enumerate(points[1:-1]):
        if points[i][1] == p[1] == points[i + 2][1]:
            continue
        else:
            result.append(p)
    result.append(points[-1])
    return result


def main():
    root = tk.Tk()
    root.minsize(480, 270)
    root.geometry('500x500+100+100')
    graph1 = RSSIGraph(root)
    # graph2 = NoiseGraph(root)
    # graph3 = ReceptionGraph(root)
    # graph4 = StatisticGraph(root)

    graph1.grid(row=0, column=0, sticky=tk.NSEW)
    # graph2.grid(row=0, column=1, sticky=tk.NSEW)
    # graph3.grid(row=1, column=0, sticky=tk.NSEW)
    # graph4.grid(row=1, column=1, sticky=tk.NSEW)

    root.rowconfigure(0, weight=1)
    root.columnconfigure(0, weight=1)
    # root.rowconfigure(1, weight=1)
    # root.columnconfigure(1, weight=1)

    # graph1.bottom, graph1.top = -120, 10
    # graph2.bottom, graph2.top = -120, 10
    # graph3.bottom, graph3.top = -120, 10
    # graph4.bottom, graph4.top = -120, 10

    generator_speed, update_speed = 0.3, 1
    for gr in (graph1, ):  # graph2, graph3, graph4):
        gr.bind('<Configure>', gr.update_dimension)
    # sleep(2)
    rxm = RXSimulator(graph1, 'RXS', generator_speed)
    # rxs = RXSimulator(graph1, 'RXS', generator_speed)
    rxm.start()
    # rxs.start()
    Thread(target=graph_updater, args=([graph1], update_speed), daemon=True).start()
    # root.protocol('WM_DELETE_WINDOW', lambda: close(graph.button_colors, root))
    # Thread(target=generator, args=(graph, graph.left, graph.right), daemon=True).start()
    root.mainloop()
    # rxm.print_rssi()


if __name__ == '__main__':
    main()
    # x = [-9, -9, -37, -10, -8, -9, -35, -11, -10, -10, -48, -8, -63, -126, -127, -126, -126, -126, -125, -126, -126,
    #      -126, -126, -90, -109]
    # x.sort()
    # y = [v-x[i] for i, v in enumerate(x[1:])]
    # print(x)
    # print(y)
