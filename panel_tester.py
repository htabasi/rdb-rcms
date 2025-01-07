
from prompt_toolkit import Application
from prompt_toolkit.layout import Layout, HSplit, VerticalAlign
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.output import ColorDepth
from prompt_toolkit.styles import Style

from director.panel.panel import Panel



panel = Panel({2: {'name': 'ANK', 'fc': 3},
               6: {'name': 'BUZ', 'fc': 3},
               7: {'name': 'BJD', 'fc': 3},
               20: {'name': 'MSD', 'fc': 2}})

kb = KeyBindings()


@kb.add('a')
def _(event):
    panel.add_station('KMS', 13, 3)

@kb.add('r')
def _(event):
    panel.remove_station('KMS')

@kb.add('d')
def _(event):
    panel.remove_code(20)

@kb.add('c')
def _(event):
    panel.update_status('ANK', 2, 'TXM', 'cyan', 'ansicyan')

@kb.add('m')
def _(event):
    panel.update_status('ANK', 1, 'TXM', 0, 0)
    panel.update_status('ANK', 1, 'TXS', 0, 1)
    panel.update_status('ANK', 1, 'RXM', 0, 2)
    panel.update_status('ANK', 1, 'RXS', 0, 3)

    panel.update_status('ANK', 2, 'TXM', 1, 0)
    panel.update_status('ANK', 2, 'TXS', 1, 1)
    panel.update_status('ANK', 2, 'RXM', 1, 2)
    panel.update_status('ANK', 2, 'RXS', 1, 3)

    panel.update_status('ANK', 3, 'TXM', 2, 0)
    panel.update_status('ANK', 3, 'TXS', 2, 1)
    panel.update_status('ANK', 3, 'RXM', 2, 2)
    panel.update_status('ANK', 3, 'RXS', 2, 3)

    panel.update_status('BUZ', 1, 'TXM', 3, 0)
    panel.update_status('BUZ', 1, 'TXS', 3, 1)
    panel.update_status('BUZ', 1, 'RXM', 3, 2)
    panel.update_status('BUZ', 1, 'RXS', 3, 3)

    panel.update_status('BUZ', 2, 'TXM', 4, 0)
    panel.update_status('BUZ', 2, 'TXS', 4, 1)
    panel.update_status('BUZ', 2, 'RXM', 4, 2)
    panel.update_status('BUZ', 2, 'RXS', 4, 3)

    panel.update_status('BUZ', 3, 'TXM', 5, 0)
    panel.update_status('BUZ', 3, 'TXS', 5, 1)
    panel.update_status('BUZ', 3, 'RXM', 5, 2)
    panel.update_status('BUZ', 3, 'RXS', 5, 3)

    panel.update_status('BJD', 1, 'TXM', 6, 0)
    panel.update_status('BJD', 1, 'TXS', 6, 1)
    panel.update_status('BJD', 1, 'RXM', 6, 2)
    panel.update_status('BJD', 1, 'RXS', 6, 3)

    panel.update_status('BJD', 2, 'TXM', 3, 1)
    panel.update_status('BJD', 2, 'TXS', 3, 1)
    panel.update_status('BJD', 2, 'RXM', 3, 1)
    panel.update_status('BJD', 2, 'RXS', 3, 1)

    panel.update_status('BJD', 3, 'TXM', 3, 1)
    panel.update_status('BJD', 3, 'TXS', 3, 1)
    panel.update_status('BJD', 3, 'RXM', 3, 1)
    panel.update_status('BJD', 3, 'RXS', 3, 1)


@kb.add('q')
def _(event):
    event.app.exit()

style = Style.from_dict({ 'background': 'bg:#1c1a27', })

app = Application(layout=panel, key_bindings=kb, full_screen=True, color_depth=ColorDepth.DEPTH_24_BIT, style=style)
app.run()
