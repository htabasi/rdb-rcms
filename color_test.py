from prompt_toolkit import Application
from prompt_toolkit.layout import Layout, HSplit, Window
from prompt_toolkit.layout.controls import FormattedTextControl
from prompt_toolkit.formatted_text import HTML
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.styles import Style
from prompt_toolkit.styles.base import ANSI_COLOR_NAMES

colors = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"] + ANSI_COLOR_NAMES

windows = []
for color in colors:
    text = HTML(f'<a fg="{color}" bg="black"> {color} </a>')
    window = Window(content=FormattedTextControl(text=text), height=1)
    windows.append(window)

layout = Layout(HSplit(windows))

kb = KeyBindings()

@kb.add('q')
def _(event):
    event.app.exit()

app = Application(layout=layout, key_bindings=kb, full_screen=True)

app.run()
