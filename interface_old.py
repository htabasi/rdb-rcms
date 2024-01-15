from consolemenu import ConsoleMenu, SelectionMenu
from consolemenu.items import FunctionItem, SubmenuItem, ExitItem
from consolemenu.menu_formatter import MenuFormatBuilder
from consolemenu.menu_component import Dimension
from threading import Thread
from colorama import init, Fore, Style, Back
from itertools import cycle
from time import sleep


class NewExitItem(ExitItem):
    def __init__(self, text="Exit", menu=None, exit_function=None):
        super(NewExitItem, self).__init__(text=text, menu=menu)
        self.on_exit_function = exit_function

    def action(self):
        self.on_exit_function()


class MyConsoleMenu(ConsoleMenu):
    def __init__(self, title=None, subtitle=None, screen=None, formatter=None,
                 prologue_text=None, epilogue_text=None,
                 show_exit_option=True, exit_option_text='Exit', on_exit_function=None):
        super(MyConsoleMenu, self).__init__(title=title, subtitle=subtitle, screen=screen, formatter=formatter,
                                            prologue_text=prologue_text, epilogue_text=epilogue_text,
                                            show_exit_option=show_exit_option, exit_option_text=exit_option_text)
        self.exit_item = NewExitItem(menu=self, text=exit_option_text, exit_function=on_exit_function)


class UserInterface:
    def __init__(self, config, to_rx: Queue, from_rx: Queue, print_continue: list, last_logs: list,
                 last_log_numbers: list, to_tx: Queue = None, from_tx: Queue = None, exit_function=None, exit_args=None,
                 reset_args=None, reset_to_fixed_mode_args=None):
        self.config = config
        self.check_port_configuration()

        if exit_function is None:
            exit_function = exit
        self.no_tx = to_tx is None
        self.scan_paused = False
        self.last_connection_stat = None

        self.print_continue = print_continue
        self.to_rx, self.from_rx = to_rx, from_rx
        self.to_tx, self.from_tx = to_tx, from_tx
        self.last_logs = last_logs
        self.last_log_numbers = last_log_numbers
        self.initial_rx_parameters = {}
        title = self.config.get("application_configuration").get("name_title")
        subtitle = self.config.get("application_configuration").get("name_subtitle")
        self.epilogue_enable = int(self.config.get("application_configuration").get("epilogue_connection_stat"))

        # self.initial_rx_parameters = {'FFSR': 10, 'FFSN': 15, 'FFSL': 'OR', 'FFCO': 'Enabled', 'GRIS': 'Low Noise',
        #                               'FFSQ': 'ON', 'MSAC': 'Active', 'AIGA': 'Enabled', 'AILA': 0, 'AIAD': 0,
        #                               'FFSP': '25 KHz'}
        self.initial_rx_request = ['FFSR', 'FFSN', 'FFSL', 'FFCO', 'GRIS', 'FFSQ', 'MSAC', 'AIGA', 'AILA', 'AIAD',
                                   'FFSP']
        self.rx_reset_need_parameters = []
        self.rx_wait_to_reset_parameters = {}

        self.initial_tx_parameters = {}
        # self.initial_tx_parameters = {'RCMG': 90, 'RCLP': 5, 'RCNP': 50, 'RCTS': 'Normal', 'AILA': 0, 'AIAD': 0,
        #                               'AICA': 'Enable', 'FFTO': '+7.5', 'FFSP': '25 KHz', 'MSAC': 'Active'}
        self.initial_tx_request = ['RCMG', 'RCLP', 'RCNP', 'RCTS', 'AILA', 'AIAD', 'AICA', 'FFTO', 'FFSP', 'MSAC']
        self.tx_reset_need_parameters = []
        self.tx_wait_to_reset_parameters = {}

        self.main_menu = ConsoleMenu('Main Menu', title, show_exit_option=False, prologue_text=subtitle,
                                     formatter=MenuFormatBuilder(Dimension(width=160, height=40)))

        """             Radio Control Menu              """

        self.radio_control_menu = ConsoleMenu('Radio Control Menu', 'View, Config and Control Rx or Tx')
        # ------ Item for Main menu
        self.radio_control_item = SubmenuItem('Radio Control', self.radio_control_menu, menu=self.main_menu)
        # ------ Item for Radio Control menu
        self.view_rx_parameters_item = FunctionItem("View Current RX Setting", lambda: self.list_radio_settings('RX'))
        self.view_tx_parameters_item = FunctionItem("View Current TX Setting", lambda: self.list_radio_settings('TX'))

        # RX Configuration SubMenu
        # self.send_command_to_rx_menu = ConsoleMenu('Reconfigure RX Settings')
        self.send_command_to_rx_menu = MyConsoleMenu('Reconfigure RX Settings',
                                                     on_exit_function=self.restart_radio_if_need)
        # ------ Item for Radio Control menu
        self.send_command_to_rx_item = SubmenuItem('Reconfigure RX', self.send_command_to_rx_menu,
                                                   menu=self.radio_control_menu)
        # ------ Items for submenu
        self.set_rssi_sq_thr_item = FunctionItem("Set RSSI SQ Threshold",
                                                 lambda: self.set_rx_item('FFSR'))
        self.set_snr_sq_thr_item = FunctionItem("Set S/N SQ Threshold",
                                                lambda: self.set_rx_item('FFSN'))
        self.set_sq_logic_item = FunctionItem("Set SQ Logic Operation",
                                              lambda: self.set_rx_item('FFSL', reset_need=True))
        self.set_carrier_override_item = FunctionItem("Set Carrier Override",
                                                      lambda: self.set_rx_item('FFCO', reset_need=True))
        self.set_input_sensitivity_item = FunctionItem("Set RX Input Sensitivity",
                                                       lambda: self.set_rx_item('GRIS', reset_need=True))
        self.set_sq_circuit_item = FunctionItem("Set SQ Circuit On/Off", lambda: self.set_rx_item('FFSQ'))
        self.set_rx_active_item = FunctionItem("Set RX Active/Inactive", lambda: self.set_rx_item('MSAC'))
        self.set_audio_agc_item = FunctionItem("Set RX Audio AGC", lambda: self.set_rx_item('AIGA', reset_need=True))
        self.set_rx_audio_level_item = FunctionItem("Set RX Audio level", lambda: self.set_rx_item('AILA'))
        self.set_audio_delay_item = FunctionItem("Set RX Audio Delay", lambda: self.set_rx_item('AIAD'))
        self.set_rx_channel_spacing_item = FunctionItem('Set Channel Spacing', lambda: self.set_rx_item('FFSP'))
        self.restart_rx_item = FunctionItem("Restart Radio", lambda: self.set_rx_item('RCRR'))

        # ------ Adding Items to submenu
        self.send_command_to_rx_menu.append_item(self.set_rssi_sq_thr_item)
        self.send_command_to_rx_menu.append_item(self.set_snr_sq_thr_item)
        self.send_command_to_rx_menu.append_item(self.set_sq_logic_item)
        self.send_command_to_rx_menu.append_item(self.set_carrier_override_item)
        self.send_command_to_rx_menu.append_item(self.set_input_sensitivity_item)
        self.send_command_to_rx_menu.append_item(self.set_sq_circuit_item)
        self.send_command_to_rx_menu.append_item(self.set_rx_active_item)
        self.send_command_to_rx_menu.append_item(self.set_audio_agc_item)
        self.send_command_to_rx_menu.append_item(self.set_rx_audio_level_item)
        self.send_command_to_rx_menu.append_item(self.set_audio_delay_item)
        self.send_command_to_rx_menu.append_item(self.restart_rx_item)

        # TX Configuration SubMenu
        self.send_command_to_tx_menu = MyConsoleMenu('Reconfigure TX Settings',
                                                     on_exit_function=self.restart_radio_if_need)
        # ------ Item for Radio Control menu
        self.send_command_to_tx_item = SubmenuItem('Reconfigure TX', self.send_command_to_tx_menu,
                                                   menu=self.radio_control_menu)
        # ------ Items for submenu
        self.press_without_audio_1 = FunctionItem(f"Press TX WITHOUT Audio {TX_PRESS_LENGTH[0]} second",
                                                  lambda: self.press_tx('RCPF', TX_PRESS_LENGTH[0]))
        self.press_without_audio_2 = FunctionItem(f"Press TX WITHOUT Audio {TX_PRESS_LENGTH[1]} second",
                                                  lambda: self.press_tx('RCPF', TX_PRESS_LENGTH[1]))
        self.press_with_audio_1 = FunctionItem(f"Press TX WITH Audio {TX_PRESS_LENGTH[0]} second",
                                               lambda: self.press_tx('RCPT', TX_PRESS_LENGTH[0]))
        self.press_with_audio_2 = FunctionItem(f"Press TX WITH Audio {TX_PRESS_LENGTH[1]} second",
                                               lambda: self.press_tx('RCPT', TX_PRESS_LENGTH[1]))
        self.set_modulation_depth_item = FunctionItem('Set TX Modulation Depth', lambda: self.set_tx_item('RCMG'))
        self.set_tx_low_power_level_item = FunctionItem('Set TX Low Power Level', lambda: self.set_tx_item('RCLP'))
        self.set_tx_normal_power_level_item = FunctionItem('Set TX Normal Power Level',
                                                           lambda: self.set_tx_item('RCNP'))
        self.set_tx_power_level_item = FunctionItem('Set TX Power Level', lambda: self.set_tx_item('RCTS'))
        self.set_tx_audio_level_item = FunctionItem('Set TX Audio Level', lambda: self.set_tx_item('AILA'))
        self.set_tx_audio_delay_item = FunctionItem('Set TX Audio Delay', lambda: self.set_tx_item('AIAD'))
        self.set_tx_audio_alc_item = FunctionItem('Set TX Audio ALC', lambda: self.set_tx_item('AICA', reset_need=True))
        self.set_tx_carrier_offset_item = FunctionItem('Set Carrier Offset', lambda: self.set_tx_item('FFTO'))
        self.set_tx_channel_spacing_item = FunctionItem('Set Channel Spacing', lambda: self.set_tx_item('FFSP'))
        self.set_tx_active_item = FunctionItem("Set TX Active/Inactive", lambda: self.set_tx_item('MSAC'))
        self.restart_tx_item = FunctionItem("Restart Radio", lambda: self.set_tx_item('RCRR'))

        # ------ Adding Items to submenu
        self.send_command_to_tx_menu.append_item(self.press_without_audio_1)
        self.send_command_to_tx_menu.append_item(self.press_without_audio_2)
        self.send_command_to_tx_menu.append_item(self.press_with_audio_1)
        self.send_command_to_tx_menu.append_item(self.press_with_audio_2)
        self.send_command_to_tx_menu.append_item(self.set_modulation_depth_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_low_power_level_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_normal_power_level_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_power_level_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_audio_level_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_audio_delay_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_audio_alc_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_carrier_offset_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_channel_spacing_item)
        self.send_command_to_tx_menu.append_item(self.set_tx_active_item)
        self.send_command_to_tx_menu.append_item(self.restart_tx_item)

        # ------ Adding Items to Radio Control menu
        self.radio_control_menu.append_item(self.view_rx_parameters_item)
        self.radio_control_menu.append_item(self.view_tx_parameters_item)
        self.radio_control_menu.append_item(self.send_command_to_rx_item)
        self.radio_control_menu.append_item(self.send_command_to_tx_item)

        """             Application Configuration Menu              """

        self.application_config_menu = ConsoleMenu('Application Configuration Menu',
                                                   'View and Edit Predefined Configuration')
        # ------ Item for Main menu
        self.application_config_item = SubmenuItem("Application Configuration", self.application_config_menu,
                                                   menu=self.main_menu)
        # ------ Item for Application menu
        self.view_radio_config_item = FunctionItem("View Predefined Radio configuration",
                                                   lambda: self.list_configuration('radio_configuration'))
        self.view_export_item = FunctionItem("View RX Data Export configuration",
                                             lambda: self.list_configuration('export_data_configuration'))
        self.view_scan_item = FunctionItem("View frequency scan configuration for transmitter and receiver",
                                           lambda: self.list_configuration('scan_frequencies_configuration'))
        self.reload_config_item = FunctionItem("Discard changes and reload configuration", self.discard_and_reload)
        self.save_config_item = FunctionItem("Save all changes on configuration to file", self.save_configuration)

        # Radio Configuration SubMenu
        self.radio_select_submenu = ConsoleMenu('Select Radio to Config')
        # ------ Item for Application menu
        self.config_radio_item = SubmenuItem("Define Radio configuration",
                                             self.radio_select_submenu, menu=self.application_config_menu)
        # ------ Items for submenu
        self.config_rx_item = FunctionItem("Define RX Configuration",
                                           lambda: self.configure_item(["radio_configuration", "rx"]))
        self.config_tx_item = FunctionItem("Define TX Configuration",
                                           lambda: self.configure_item(["radio_configuration", "tx"]))
        # ------ Adding Items to submenu
        self.radio_select_submenu.append_item(self.view_radio_config_item)
        self.radio_select_submenu.append_item(self.config_rx_item)
        self.radio_select_submenu.append_item(self.config_tx_item)

        # Data Export Configuration SubMenu
        self.config_export_submenu = ConsoleMenu('Select item to Config')
        # ------ Item for Application menu
        self.config_export_item = SubmenuItem("Define Export configuration",
                                              self.config_export_submenu, menu=self.application_config_menu)
        # ------ Items for submenu
        self.config_export_file = FunctionItem("RSSI Export File",
                                               lambda: self.configure_item(
                                                   ["export_data_configuration", "export_rssi_file"]))
        # ------ Adding Items to submenu
        self.config_export_submenu.append_item(self.view_export_item)
        self.config_export_submenu.append_item(self.config_export_file)

        # Frequency Scan Configuration SubMenu
        self.config_scan_submenu = ConsoleMenu('Select item to Config')
        # ------ Item for Application menu
        self.config_scan_item = SubmenuItem("Define frequency scan configuration",
                                            self.config_scan_submenu, menu=self.application_config_menu)
        # ------ Items for submenu
        self.config_scan_interval = FunctionItem("Frequency Scan interval",
                                                 lambda: self.configure_item(
                                                     ["scan_frequencies_configuration", "frequency_scan_interval_(s)"]))
        self.add_to_frequency = FunctionItem("Add to Frequency List", self.add_to_frequency_list)
        self.remove_from_frequency = FunctionItem("Remove a Frequency from List", self.remove_from_frequency_list)
        self.clear_freq_list = FunctionItem("Clear Frequency List", self.clear_frequency_list)
        # ------ Adding Items to submenu
        self.config_scan_submenu.append_item(self.view_scan_item)
        self.config_scan_submenu.append_item(self.config_scan_interval)
        self.config_scan_submenu.append_item(self.add_to_frequency)
        self.config_scan_submenu.append_item(self.remove_from_frequency)
        self.config_scan_submenu.append_item(self.clear_freq_list)

        # ------ Adding Items to Application Menu
        self.application_config_menu.append_item(self.view_radio_config_item)
        self.application_config_menu.append_item(self.view_export_item)
        self.application_config_menu.append_item(self.view_scan_item)
        self.application_config_menu.append_item(self.config_radio_item)
        self.application_config_menu.append_item(self.config_export_item)
        self.application_config_menu.append_item(self.config_scan_item)
        self.application_config_menu.append_item(self.reload_config_item)
        self.application_config_menu.append_item(self.save_config_item)

        """             Other Parts in Main Menu              """

        self.list_last_logs_item = FunctionItem(f"List Last Log Reports", self.list_last_logs)
        self.pause_scanner_item = FunctionItem(f"Pause or Continue Frequency Scanner", self.pause_scanner)
        self.set_frequency_item = FunctionItem(f"Set Frequency (Only available when Scan Paused)", self.set_frequency)
        self.restart_application_item = FunctionItem("Restart Application", lambda: exit_function(*reset_args))
        self.restart_to_fix_item = FunctionItem("Restart Application to fixed Frequency mode",
                                                lambda: exit_function(*reset_to_fixed_mode_args))
        self.exit_item = FunctionItem("Close Connection and Exit", lambda: exit_function(*exit_args))

        # ------ Adding Items to Main Menu

        self.main_menu.append_item(self.radio_control_item)
        self.main_menu.append_item(self.application_config_item)
        self.main_menu.append_item(self.list_last_logs_item)
        self.main_menu.append_item(self.pause_scanner_item)
        self.main_menu.append_item(self.set_frequency_item)
        self.main_menu.append_item(self.restart_application_item)
        self.main_menu.append_item(self.restart_to_fix_item)
        self.main_menu.append_item(self.exit_item)

        # self.main_menu.show()

        self.key_to_item_converter = {'RX':
                                          {'FFSR': self.set_rssi_sq_thr_item,
                                           'FFSN': self.set_snr_sq_thr_item,
                                           'FFSL': self.set_sq_logic_item,
                                           'FFCO': self.set_carrier_override_item,
                                           'GRIS': self.set_input_sensitivity_item,
                                           'FFSQ': self.set_sq_circuit_item,
                                           'MSAC': self.set_rx_active_item,
                                           'AIGA': self.set_audio_agc_item,
                                           'AILA': self.set_rx_audio_level_item,
                                           'AIAD': self.set_audio_delay_item,
                                           'FFSP': self.set_rx_channel_spacing_item
                                           },
                                      'TX':
                                          {'RCMG': self.set_modulation_depth_item,
                                           'RCLP': self.set_tx_low_power_level_item,
                                           'RCNP': self.set_tx_normal_power_level_item,
                                           'RCTS': self.set_tx_power_level_item,
                                           'AILA': self.set_tx_audio_level_item,
                                           'AIAD': self.set_tx_audio_delay_item,
                                           'AICA': self.set_tx_audio_alc_item,
                                           'FFTO': self.set_tx_carrier_offset_item,
                                           'FFSP': self.set_tx_channel_spacing_item,
                                           'MSAC': self.set_tx_active_item

                                           }
                                      }

        self.before_space, self.key_part, self.value_part = 0, 29, 49

        self.corner_top_right = chr(9559)
        self.corner_top_left = chr(9556)
        self.corner_bottom_left = chr(9562)
        self.corner_bottom_right = chr(9565)
        self.horizontal = chr(9552)
        self.vertical = chr(9553)
        self.top_cross = chr(9574)
        self.bottom_cross = chr(9577)
        self.left_cross = chr(9568)
        self.right_cross = chr(9571)
        self.center_cross = chr(9580)
        self.sub_horizontal = chr(9472)
        self.sub_left_cross = chr(9567)
        self.sub_right_cross = chr(9570)
        self.sub_top_cross = chr(9576)
        self.sub_bottom_cross = chr(9573)

    def set_frequency(self):
        if not self.scan_paused:
            self.print_message('Please stop scanning mode before setting a new frequency.')
            return

        new_freq = self.get_new_parameter('scan_list', add=True)
        if new_freq:
            if self.check_remote('RX'):  # and (self.no_tx or self.check_remote('TX')):
                self.to_rx.put(('RadioCommand', *self.get_command('FFSP', {25: 3, 8.33: 1}.get(new_freq[1]))))
                sleep(0.2)
                self.to_rx.put(('RadioCommand', *self.get_command('FFTR', new_freq[0])))

    def pause_scanner(self):
        self.to_rx.put(('HoldScan',))
        if not self.no_tx:
            self.to_tx.put(('HoldScan',))
        self.scan_paused = not self.scan_paused
        self.update_epilogue_text()

    def list_last_logs(self):
        kp, vp = 14, 84
        self.print_title('Last Logs', 'Time', 'Log Message', kp, vp)
        for dt, msg in self.last_logs:
            t = str(dt.time())[:8]
            self.print_value(t, msg, kp, vp, '<')

        self.print_finish_line(kp, vp)
        self.print_message('Press <Enter> Key To Continue')

    def update_epilogue_text(self, connection_stat: list = None):
        if connection_stat is None:
            connection_stat = self.last_connection_stat
        else:
            self.last_connection_stat = connection_stat.copy()

        if connection_stat is None:
            return
        if self.epilogue_enable:
            converter = {0: f"{Fore.LIGHTRED_EX}NOK{Style.RESET_ALL}", 1: f"{Fore.LIGHTGREEN_EX}OK{Style.RESET_ALL} "}
            epi_text = ''
            if self.no_tx:
                names = ['RXM', 'CON', 'ACT', 'REM', 'LOG']
            else:
                names = ['RXM', 'CON', 'ACT', 'REM', 'TXM', 'CON', 'ACT', 'REM', 'LOG']
            for i, stat in enumerate(connection_stat[:-1]):
                epi_text += f'{names[i]}:{converter.get(stat)}'

            scan_stat = {False: f"{Fore.LIGHTGREEN_EX}OK{Style.RESET_ALL}",
                         True: f"{Back.LIGHTYELLOW_EX}{Fore.BLUE}Paused{Style.RESET_ALL}"}.get(self.scan_paused)
            epi_text += f'SCAN:{scan_stat}'
            self.main_menu.epilogue_text = epi_text
            self.main_menu.clear_screen()
            self.main_menu.draw()

    def restart_radio_if_need(self):
        if self.rx_reset_need_parameters:
            self.to_rx.put(('RadioCommand', 'RC', 'RR', 'S'))
            input(f'Please Wait about 1 minute for RX to connect again.\nPress <Enter> to Continue...')
            for key in self.rx_reset_need_parameters:
                self.initial_rx_parameters[key] = self.rx_wait_to_reset_parameters[key]
            return True

        if self.tx_reset_need_parameters:
            self.to_tx.put(('RadioCommand', 'RC', 'RR', 'S'))
            input('Please Wait about 1 minute for TX to connect again.\nPress <Enter> to Continue...')
            for key in self.tx_reset_need_parameters:
                self.initial_tx_parameters[key] = self.tx_wait_to_reset_parameters[key]
            return True

    def check_connection(self, radio):
        global SMALL
        if SMALL[{'RX': RX_CON, 'TX': TX_CON}.get(radio)]:
            return True
        else:
            self.print_message(f'Error: {radio} is Not Connected.')
            return False

    def check_remote(self, radio):
        global SMALL
        if self.check_connection(radio):
            if SMALL[{'RX': RX_REM, 'TX': TX_REM}.get(radio)]:
                return True
            else:
                self.print_message(f'Error: Connection to {radio} is Not in REMOTE stat.')

    def check_activation(self, radio):
        global SMALL
        if self.check_remote(radio):
            if SMALL[{'RX': RX_ACT, 'TX': TX_ACT}.get(radio)]:
                return True
            else:
                self.print_message(f'Error: {radio} is Not Active.')

    def list_radio_settings(self, radio):
        initial_parameter = {'RX': self.initial_rx_parameters, 'TX': self.initial_tx_parameters}.get(radio)
        if len(initial_parameter) == 0:
            if self.check_connection(radio):
                self.run_initial_request(radio)
            else:
                return
        initial_parameter = {'RX': self.initial_rx_parameters, 'TX': self.initial_tx_parameters}.get(radio)
        self.print_title(f'{radio} Current Settings', f'{radio} Parameter', 'Parameter Value')
        for key in initial_parameter:
            name = command_translator.get(key)
            if key in command_value_translator and initial_parameter.get(key) != 'NOT_SUPPORTED':
                self.print_value(name, command_value_translator.get(key).get(int(initial_parameter.get(key))))
            else:
                self.print_value(name, initial_parameter.get(key))

        self.print_finish_line()
        self.print_message('Press <Enter> Key To Continue')

    def run_initial_request(self, radio):
        start_time = time()
        rqt = Thread(target=self.request_initial_parameters, args=(radio,), name='Request Thread', daemon=True)
        rqt.start()
        rotator = cycle(['-', '\\', '|', '/'])
        while rqt.is_alive():
            print(f'Please Wait to collect RX Parameters ...{next(rotator)}\r', end='')
            rqt.join(0.5)
        self.print_message(f'All Needed RX Parameters Collected in {time() - start_time:5.3} seconds.')
        initial_parameter = {'RX': self.initial_rx_parameters, 'TX': self.initial_tx_parameters}.get(radio)
        for key in initial_parameter:
            if initial_parameter[key] == 'NOT_SUPPORTED':
                item = self.key_to_item_converter.get(radio).get(key)
                item.text += f' {chr(171)} NOT SUPPORTED {chr(187)}'
                item.function = lambda: self.print_message(
                    'This Item is not Supported for this version of radio.')

    def request_initial_parameters(self, radio):
        if radio == 'RX':
            initial_request = self.initial_rx_request
            send_queue = self.to_rx
            listen_queue = self.from_rx
        else:
            initial_request = self.initial_tx_request
            send_queue = self.to_tx
            listen_queue = self.from_tx

        # result = {'FFSP': 3, 'FFSR': '3', 'FFSN': '10', 'FFSL': 'NOT_SUPPORTED', 'FFCO': 'NOT_SUPPORTED',
        #  'GRIS': 'NOT_SUPPORTED', 'FFSQ': '1', 'MSAC': '1', 'AIGA': 'NOT_SUPPORTED', 'AILA': 'NOT_SUPPORTED',
        #  'AIAD': 'NOT_SUPPORTED'}

        result = {}
        send_queue.put(('NeedParameters', initial_request))
        while len(result) != len(initial_request):
            while not listen_queue.empty():
                answer = listen_queue.get()
                if answer[0] == 'CollectionAnswer':
                    result = answer[1]
                    break
                sleep(0.2)

        destination = {'RX': self.initial_rx_parameters, 'TX': self.initial_tx_parameters}.get(radio)
        for key in result:
            destination[key] = result[key]

    def set_rx_item(self, key, reset_need=False):
        """
        :param key:
            list of keys designed for config is here:
            FFSR: RSSI SQ Threshold
            FFSN: S/N SQ Threshold
            FFSL: SQ Logic Operation   (Reset Need)
            FFCO: Carrier Override     (Reset Need)
            GRIS: RX Input Sensitivity (Reset Need)
            FFSQ: SQ Circuit On/Off
            MSAC: Active/Inactive
            AIGA: RX Audio AGC         (Reset Need)
            AILA: RX Audio level
            AIAD: RX Audio Delay
            FFSP: Channel Spacing
            RCRR: Restart Radio

        :param reset_need:
            if setting a parameter need to reset radio then this parameter describe it.
        :return:
            None
        """
        if reset_need:
            self.set_radio_parameter('RX', key, self.initial_rx_parameters, reset_need, self.to_rx,
                                     self.rx_wait_to_reset_parameters, self.rx_reset_need_parameters)
        else:
            self.set_radio_parameter('RX', key, self.initial_rx_parameters, reset_need, self.to_rx)

    def set_tx_item(self, key, reset_need=False):
        """
        :param key:
            list of keys designed for config is here:
            RCPF: Press TX WITHOUT Audio
            RCPT: Press TX WITH Audio
            RCMG: TX Modulation Depth
            RCLP: TX Low Power Level
            RCNP: TX Normal Power Level
            RCTS: TX Power Level
            AILA: TX Audio Level
            AIAD: TX Audio Delay
            AICA: TX Audio ALC
            FFTO: Carrier Offset
            FFSP: Channel Spacing
            MSAC: TX Active/Inactive
            RCRR: Restart Radio

        :param reset_need:
            if setting a parameter need to reset radio then this parameter describe it.
        :return:
            None
        """
        if reset_need:
            self.set_radio_parameter('TX', key, self.initial_tx_parameters, reset_need, self.to_tx,
                                     self.tx_wait_to_reset_parameters, self.tx_reset_need_parameters)
        else:
            self.set_radio_parameter('TX', key, self.initial_tx_parameters, reset_need, self.to_tx)

    def set_radio_parameter(self, radio, key, initial_parameters, reset_need, to_radio, wait_to_reset=None,
                            reset_need_parameters=None):
        if not self.check_remote(radio):
            return

        if key in ['RCRR']:
            print(f"{chr(171)} 'Are you sure you want to restart the {radio}? (YES/NO)' {chr(187)}", end="")
            answer = input()
            if answer.upper() in ['Y', 'YES']:
                to_radio.put(('RadioCommand', 'RC', 'RR', 'S'))
                print('Please Wait about 1 minute for RX to connect again.')
                return
        if key not in initial_parameters:
            self.run_initial_request(radio)

        new_value = self.get_new_radio_parameter(key, initial_parameters[key])
        if new_value == 'NO_ERROR':
            self.print_message('No Change has made!')
            return
        if new_value is not None:
            to_radio.put(('RadioCommand', *self.get_command(key, new_value)))
            if key in parameter_valid_range:
                # input(f"{key} {new_value} {type(new_value)} ")
                if key == 'FFSR':
                    hint = f" uv equal to {self.get_dbm(int(new_value))} dBm"
                else:
                    hint = ""

                msg = f'{command_translator.get(key)} Updated from {initial_parameters[key]} to {new_value}{hint}.'
            else:
                msg = f'{command_translator.get(key)} Updated from ' \
                      f'{command_value_translator.get(key).get(int(initial_parameters[key]))} to ' \
                      f'{command_value_translator.get(key).get(new_value)}.'
            if reset_need:
                wait_to_reset[key] = new_value
                reset_need_parameters.append(key)
                msg += '\n Note: Don`t forget to restart radio to new value take affect.'
            else:
                initial_parameters[key] = new_value

            self.print_message(msg)
        else:
            self.print_message('Error: The Entered Value is not acceptable!')

    def press_tx(self, key, length):
        if not self.check_activation('TX'):
            return
        self.print_continue[1] = True
        self.to_tx.put(('RadioCommand', *self.get_command(key, 1)))
        sleep(length)
        self.to_tx.put(('RadioCommand', *self.get_command(key, 0)))
        self.print_continue[1] = False

    @staticmethod
    def get_dbm(uv: int):
        return -107 + 20 * log10(uv)

    def get_new_radio_parameter(self, key, current):
        """
        RX
        'FFSR': 10, 'FFSN': 15, 'FFSL': 'OR', 'FFCO': 'Enable', 'GRIS': 'Low Noise',
        'FFSQ': 'ON', 'MSAC': 'Active', 'AIGA': 'Enable', 'AILA': 0, 'AIAD': 0,
        'FFSP': '25 KHz'
        TX
        'RCMG': 90, 'RCLP': 5, 'RCNP': 50, 'RCTS': 'Normal', 'AILA': 0, 'AIAD': 0,
        'AICA': 'Enable', 'FFTO': '+7.5', 'FFSP': '25 KHz', 'MSAC': 'Active'

        Numbers:
            FFSR, FFSN, AILA, AIAD, RCMG, RCLP, RCNP

        Selection:
            FFSL, FFCO, GRIS, FFSQ, MSAC, AIGA, FFSP, RCTS, AICA, FFTO

        """
        name = command_translator.get(key)
        if key in parameter_valid_range:
            if key == 'FFSR':
                hint = f" uv equal to {self.get_dbm(int(current))} dBm"
            else:
                hint = ""

            text_value = input(f'Current value of {name} is {current}{hint}.\nEnter New value in range '
                               f'[{parameter_valid_range[key].start}, {parameter_valid_range[key].end}] to set, or '
                               f'press <Enter> to cancel:')
            if text_value == '':
                return 'NO_ERROR'
            value = parameter_valid_range[key].convert(text_value)
            if parameter_valid_range[key].valid(value):
                return value
            else:
                return
        else:
            selection_list = list(command_value_translator.get(key).values())
            # print(current, selection_list, command_value_translator)
            current_index = selection_list.index(command_value_translator.get(key).get(int(current)))
            selection_list[current_index] += ' - Current Value'
            index = SelectionMenu.get_selection(selection_list, title=f'Select an option for "{name}"')
            if index == current_index:
                return 'NO_ERROR'
            try:
                return command_key_translator.get(key).get(selection_list[index])
            except IndexError:
                return 'NO_ERROR'

    def get_command(self, key, value):
        return key[:2], key[2:], 'S', value

    def list_configuration(self, data_title):
        title = self.embellish_text(data_title).upper()
        config = self.config.get(data_title)
        print()
        if data_title == 'scan_frequencies_configuration':
            self.print_title(title, 'Index', 'Frequency')
        else:
            self.print_title(title, 'Item', 'Value')

        for key in config:
            if type(config.get(key)) == dict:
                self.list_sub_dict_config(key, config.get(key))
            elif type(config.get(key)) == list:
                self.list_sub_list_config(key, config.get(key))
            else:
                self.print_value(self.embellish_text(key), config.get(key))

        self.print_finish_line()
        self.print_message('Press <Enter> Key To Continue')

    def check_port_configuration(self):
        config = self.config.get("radio_configuration")
        save_need = False
        if config.get('rx').get('port') != 8001:
            config.get('rx')['port'] = 8001
            save_need = True
        if config.get('tx').get('port') != 8002:
            config.get('tx')['port'] = 8002
            save_need = True
        if save_need:
            with open('configuration\\config.json', 'w') as config_file:
                json.dump(self.config, config_file)

    def configure_item(self, keys=None):
        config = self.config.get(keys[0]).get(keys[1])
        if type(config) == dict:
            base_list = list(config.keys())
            try:
                base_list.remove("radio_name")
                base_list.remove("port")
            except ValueError:
                pass
            exit_config = False
            while not exit_config:
                selection_list = [self.embellish_text(item) for item in base_list]
                index = SelectionMenu.get_selection(selection_list)
                if index == len(base_list):
                    break
                prev_value = config.get(base_list[index])
                new_value = self.get_new_parameter(base_list[index], selection_list[index],
                                                   config.get(base_list[index]))
                if new_value:
                    config[base_list[index]] = new_value
                    self.print_message(f"{selection_list[index]} Updated from {prev_value} to {new_value}.")
                    if base_list[index] == "position":
                        config["radio_name"] = (keys[1] + new_value).upper()
                    exit_config = True
        else:
            show_name = self.embellish_text(keys[1])
            new_value = self.get_new_parameter(keys[1], show_name, config)
            if new_value:
                self.config[keys[0]][keys[1]] = new_value
                self.print_message(f"{show_name} Updated from {config} to {new_value}.")

    def add_to_frequency_list(self):
        freq_list = self.config["scan_frequencies_configuration"]["scan_list"]
        new_freq = self.get_new_parameter('scan_list', add=True)
        if new_freq:
            freq_list.append(new_freq)
            self.print_message(f"{new_freq} Added to {self.embellish_text('scan_list')}.")

    def remove_from_frequency_list(self):
        freq_list = self.config["scan_frequencies_configuration"]["scan_list"]
        print(f"\n  Config >> Enter Index of Frequency that should remove. (Enter = Cancel)")
        index = input(f"   {chr(187) * 2} ")
        try:
            removed_frequency = freq_list.pop(int(index))
        except Exception as e:
            print(f'Error in Entered Value: {e.__class__.__name__}')
        else:
            print(f"{chr(171)} {removed_frequency} has removed from {self.embellish_text('scan_list')}. {chr(187)}")

    def clear_frequency_list(self):
        freq_list = self.config["scan_frequencies_configuration"]["scan_list"]
        answer = input(f"\n  Config >> Are you sure about clear Frequency List? (press 'Y' to confirm.)")
        if answer in ['Y', 'y']:
            freq_list.clear()
            self.print_message("Note that the frequency list cannot be empty when running the program.")

    def discard_and_reload(self):
        answer = input(
            f"\n  Config >> Are you sure about discard changes and reload configurations? (press 'Y' to confirm.)")
        if answer in ['Y', 'y']:
            with open(CONFIGFILE, 'r') as config_file:
                self.config = json.load(config_file)

    def save_configuration(self):
        answer = input(f"\n  Config >> Are you sure about save any changes on configurations? (press 'Y' to confirm.)")
        if answer in ['Y', 'y']:
            with open(CONFIGFILE, 'w') as config_file:
                json.dump(self.config, config_file)

    def get_new_parameter(self, key, parameter=None, current_value=None, add=False):
        if add:
            print(f"\n  Config >> Enter New Frequency. (Enter = Cancel)")
        else:
            print(f"\n  Config >> {parameter} current value is : {current_value}. Enter New value. (Enter = Cancel)")
        try:
            return self.validate(key, input(f"   {chr(187) * 2} "))
        except (IPError, StationNameError, FrequencyNameError, PositionValueError, FrequencyValeError) as e:
            self.print_message(f'Value is not acceptable! {e.message}')
        except CancelOperation:
            self.print_message(f'{CancelOperation.message}')

    def validate(self, key, value):
        if key == 'station_code':
            value = value.upper()
            if len(value) == 3:
                return value
            else:
                raise StationNameError

        elif key == 'frequency':
            left, right = self.config.get("application_configuration").get("acceptable_range").get(key)
            value = value.upper()
            if value.startswith('F'):
                try:
                    number = int(value[1:])
                except ValueError:
                    raise FrequencyNameError
                else:
                    if left <= number <= right:
                        return value
            else:
                try:
                    number = int(value)
                except ValueError:
                    raise FrequencyNameError
                else:
                    if left <= number <= right:
                        return f"F{number}"

        elif key == 'position':
            value = value.upper()
            if value in ['M', 'S', 'MAIN', 'STBY', 'STANDBY']:
                return value[0]
            raise PositionValueError

        elif key == 'ip':
            try:
                octet_list = [int(o) for o in value.split('.')]
            except ValueError:
                raise IPError
            else:
                if len(octet_list) != 4:
                    raise IPError
                value_ok = True
                for octet in octet_list:
                    value_ok = value_ok and 0 <= octet <= 255
                if not value_ok:
                    raise IPError
                return value

        elif key in ['tx_enable', 'follow_rx_frequency']:
            if value in ['0', '1']:
                return int(value)
            else:
                raise BooleanValueError

        elif key == 'export_rssi_file':
            if len(value.split('{}')) == 4 and value.endswith('.csv'):
                return value
            else:
                raise FileNameError

        elif key == 'frequency_scan_interval_(s)':
            try:
                interval = float(value)
            except ValueError:
                raise ScanIntervalError
            left, right = self.config.get("application_configuration").get("acceptable_range").get(key)
            if not (left <= interval <= right):
                raise ScanIntervalError
            else:
                return value

        elif key == 'scan_list':
            try:
                freq = int(value)
                if not (118000000 <= freq <= 136991666):
                    raise ValueError
            except ValueError:
                try:
                    float_freq = float(value)
                except ValueError:
                    raise FrequencyValeError
                else:
                    if 118 <= float_freq <= 136.990:
                        iff = int(float_freq * 1000)
                        if -0.01 < iff - (float_freq * 1000) < 0.01:
                            reminder = iff % 25
                            if reminder == 0:
                                return [iff * 1000, 25]
                            elif reminder == 5:
                                return [(iff - 5) * 1000, 8.33]
                            elif reminder == 10:
                                return [(iff - 10) * 1000 + 8333, 8.33]
                            elif reminder == 15:
                                return [(iff - 15) * 1000 + 16666, 8.33]
                    raise FrequencyValeError

            if not (118000000 <= freq <= 136991666):
                raise FrequencyValeError

            if freq % 25000 == 0:
                ch_list = ['25 KHz', '8.33 KHz']
                index = SelectionMenu.get_selection(ch_list, title='Please Select Channel Spacing:')
                if index == 0:
                    return [freq, 25]
                elif index == 1:
                    return [freq, 8.33]
                else:
                    raise CancelOperation
            elif freq % 25000 == 8333:
                return [freq, 8.33]
            elif freq % 25000 == 16666:
                return [freq, 8.33]
            else:
                raise FrequencyValeError
            # delta = freq - 25000 * (freq // 25000)
            # if delta in [0, 8333, 16666]:
            #     return freq
            # else:
            #     raise FrequencyValeError

    @staticmethod
    def print_message(message):  # , fast=False):
        print(f"{chr(171)} {message} {chr(187)}", end="")
        # if fast:
        #     pass
        #     # sleep(1)
        # else:
        input()

    def list_sub_dict_config(self, subtitle, sub_dict):
        self.print_subtitle(str(subtitle).upper())
        for key in sub_dict:
            self.print_value(self.embellish_text(key), sub_dict.get(key))

    def list_sub_list_config(self, subtitle, sub_list):
        self.print_subtitle(self.embellish_text(subtitle).upper())
        for index, value in enumerate(sub_list):
            if type(value) is list:
                text = "{} Hz & {} KHz BW".format(*value)
            else:
                text = value
            self.print_value(index, text)

    @staticmethod
    def embellish_text(text: str):
        out = ''
        for txt in text.split('_'):
            out += f"{txt.capitalize()} "
        return out[:-1]

    def print_value(self, key, value, key_part=None, value_part=None, align='^'):
        print(self.get_tow_part_line(key, value, key_part, value_part, align))

    def print_title(self, title, first_column, second_column, key_part=None, value_part=None):
        if key_part is None:
            key_part = self.key_part
        if value_part is None:
            value_part = self.value_part
        print(f"{' ' * 9}{self.corner_top_left}{self.horizontal * (key_part + value_part + 1)}"
              f"{self.corner_top_right}")
        print(f"{' ' * 9}{self.vertical}{title:^{key_part + value_part + 1}}{self.vertical}")
        print(f"{' ' * 9}{self.left_cross}{self.horizontal * key_part}{self.top_cross}"
              f"{self.horizontal * value_part}{self.right_cross}")
        print(self.get_tow_part_line(first_column, second_column, key_part, value_part))
        print(f"{' ' * 9}{self.left_cross}{self.horizontal * key_part}{self.center_cross}"
              f"{self.horizontal * value_part}{self.right_cross}")

    def print_subtitle(self, subtitle, key_part=None, value_part=None):
        if key_part is None:
            key_part = self.key_part
        if value_part is None:
            value_part = self.value_part
        print(f"{' ' * 9}{self.sub_left_cross}{self.sub_horizontal * key_part}{self.sub_top_cross}"
              f"{self.sub_horizontal * value_part}{self.sub_right_cross}")
        print(f"{' ' * 9}{self.vertical}{subtitle:^{key_part + value_part + 1}}{self.vertical}")
        print(f"{' ' * 9}{self.sub_left_cross}{self.sub_horizontal * key_part}{self.sub_bottom_cross}"
              f"{self.sub_horizontal * value_part}{self.sub_right_cross}")

    def get_tow_part_line(self, key, value, key_part=None, value_part=None, align='^'):
        if key_part is None:
            key_part = self.key_part
        if value_part is None:
            value_part = self.value_part
        return f"{' ' * 9}{self.vertical}{key:^{key_part}}{self.vertical}{value:{align}{value_part}}{self.vertical}"

    def print_finish_line(self, key_part=None, value_part=None):
        if key_part is None:
            key_part = self.key_part
        if value_part is None:
            value_part = self.value_part
        print(f"{' ' * 9}{self.corner_bottom_left}{self.horizontal * key_part}{self.bottom_cross}"
              f"{self.horizontal * value_part}{self.corner_bottom_right}")


class LineMonitor(Thread):
    def __init__(self, big: Array, small: Array, rx_alive: Value, log_alive: Value, from_log: Queue, last_logs: list,
                 last_log_len: list, print_continue: list, operation_continue: list, tx_alive: Value = None,
                 update_interval=0.3):
        super(LineMonitor, self).__init__(name='Animation_Printer', daemon=True)
        if system() == 'Windows':
            init(convert=True)
        self.big, self.small = big, small
        self.print_continue, self.operation_continue = print_continue, operation_continue
        self.no_tx = tx_alive is None
        self.alive = {'RX': rx_alive, 'TX': tx_alive, 'LOG': log_alive}
        self.from_log = from_log
        self.last_log = last_logs
        self.last_log_len = last_log_len

        self.progressbar_bg = chr(9617)
        self.progressbar_fg = chr(9608)
        self.on = f"{chr(9608) * 2}"
        self.off = f"{chr(9617) * 2}"

        self.on_char = f"{Fore.LIGHTYELLOW_EX}{self.on}"
        self.off_char = f"{Fore.LIGHTRED_EX}{self.off}"
        self.stat = {0: self.off_char, 1: self.on_char}
        self.log_stat = {0: f"{Fore.LIGHTRED_EX}{self.on}", 1: f"{Fore.LIGHTGREEN_EX}{self.on}"}
        self.multi_stat = {
            0: f"{Fore.LIGHTRED_EX}{self.on}",
            1: f"{Fore.LIGHTRED_EX}{self.on}",
            2: f"{Fore.LIGHTYELLOW_EX}{self.on}",
            3: f"{Fore.LIGHTGREEN_EX}{self.on}"
        }

        self.counter = {'RX': 0, 'TX': 0, 'LOG': 0}
        self.die_detect = {'RX': False, 'TX': False, 'LOG': False}
        self.die_time = {'RX': 0, 'TX': 0, 'LOG': 0}
        self.rotator = cycle([f"{Fore.LIGHTYELLOW_EX}{chr(9600)} ", f"{Fore.LIGHTGREEN_EX} {chr(9600)}",
                              f"{Fore.LIGHTYELLOW_EX} {chr(9604)}", f"{Fore.LIGHTGREEN_EX}{chr(9604)} "])
        self.progressbar_length = 20

        self.max_rotator_stop = 2
        self.rotator_stop = self.max_rotator_stop
        self.rotate = next(self.rotator)
        r = Style.RESET_ALL

        self.rx_part = f'RX {{}}{{:^7.3f}}{r} CON: {{:2}}{r} ACS: {{:2}}{r} SQ: {{:2}}{r} RSSI: {{}}{{:^4}}{r} {{}}{r} | '

        self.tx_part = f'TX {{}}{{:^7.3f}}{r} CON: {{:2}}{r} ACS: {{:2}}{r} PTT: {{:2}}{r} POWER: {{}}{{:^4}}{r} MOD: ' \
                       f'{{}}{{:^4}}{r} SWR: {{}}{{:^4}}{r} | '

        self.tail = f"Log {{}} {{:>5}}{r}\r"

        self.interval = update_interval
        self.free_printed = False
        self.previous_connection_stat = self.get_connection_stat()[-1]
        self.update_connection_stat = None

    def get_connection_stat(self):
        if self.no_tx:
            result = [int(self.get_alive_stat('RX')), SMALL[RX_CON], SMALL[RX_ACT], SMALL[RX_REM],
                      int(self.get_alive_stat('LOG'))]
        else:
            result = [int(self.get_alive_stat('RX')), SMALL[RX_CON], SMALL[RX_ACT], SMALL[RX_REM],
                      int(self.get_alive_stat('TX')), SMALL[TX_CON], SMALL[TX_ACT], SMALL[TX_REM],
                      int(self.get_alive_stat('LOG'))]

        stat = 0
        for i, v in enumerate(result):
            stat += v * 2 ** i
        result.append(stat)
        return result

    def get_frequency(self, radio):
        return (118000 + self.big[{'RX': RX_FRQ, 'TX': TX_FRQ}.get(radio)]), \
               self.small[{'RX': RX_CHS, 'TX': TX_CHS}.get(radio)]

    def get_frequency_text(self, radio):
        f, ch = self.get_frequency(radio)
        ok, warning = f"{Fore.LIGHTYELLOW_EX}{Back.LIGHTMAGENTA_EX}", f"{Fore.LIGHTMAGENTA_EX}{Back.LIGHTYELLOW_EX}",
        return f / 1000, {0: ok, 1: warning, 3: ok}.get(ch)

    def get_rssi(self):
        rssi = self.small[RX_RSSI]
        if rssi < -100:
            style = Fore.WHITE
        elif rssi < -50:
            style = Fore.LIGHTGREEN_EX
        elif rssi < -10:
            style = Fore.LIGHTYELLOW_EX
        else:
            style = Fore.LIGHTRED_EX

        return rssi, style

    def get_power(self):
        power = self.big[TX_PWR]
        if power == 0:
            style = Fore.WHITE
        elif power < 10:
            style = Fore.LIGHTRED_EX
        elif power < 45:
            style = Fore.LIGHTYELLOW_EX
        else:
            style = Fore.LIGHTGREEN_EX

        return power, style

    def get_mod(self):
        mod = self.big[TX_MOD]
        if mod == 0:
            style = Fore.WHITE
        elif mod < 30:
            style = Fore.LIGHTRED_EX
        elif mod < 80:
            style = Fore.LIGHTYELLOW_EX
        else:
            style = Fore.LIGHTGREEN_EX

        return mod, style

    def get_swr(self):
        swr = self.big[TX_SWR] / 10
        if swr == 0:
            style = Fore.WHITE
        elif swr < 1.4:
            style = Fore.LIGHTGREEN_EX
        elif swr < 1.8:
            style = Fore.LIGHTYELLOW_EX
        else:
            style = Fore.LIGHTRED_EX

        return swr, style

    def get_alive_stat(self, radio):
        alive = not self.counter[radio] == self.alive.get(radio).value
        if not alive:
            if self.die_detect.get(radio):
                if time() - self.die_time.get(radio) > 3:
                    return False
            else:
                self.die_detect[radio] = True
                self.die_time[radio] = time()
        else:
            self.die_detect[radio] = False
        return True

    def get_led(self, radio):
        alive = self.get_alive_stat(radio)
        self.counter[radio] = self.alive.get(radio).value
        con = self.small[{'RX': RX_CON, 'TX': TX_CON}.get(radio)]
        act = self.small[{'RX': RX_ACT, 'TX': TX_ACT}.get(radio)]
        rem = self.small[{'RX': RX_REM, 'TX': TX_REM}.get(radio)]
        con_stat = alive * 2 + con
        con_led = self.multi_stat.get(con_stat)
        if con_stat == 3:
            act_led = self.multi_stat.get(act * 2 + rem)
        else:
            act_led = f"{Fore.LIGHTRED_EX}{self.off}"
        return con_led, act_led

    def get_log_stat(self):
        alive = self.get_alive_stat('LOG')
        operation = self.small[LOG_OPR]
        return self.multi_stat.get(2 * alive + (1 - operation))

    def debug_operation(self):
        global DEBUG
        f, ch = self.get_frequency('RX')
        DEBUG.put(f"Animation Printer: RX Frequency: {f}, RX Channel Spacing: {ch}")
        if not self.no_tx:
            f, ch = self.get_frequency('TX')
            DEBUG.put(f"Animation Printer: TX Frequency: {f}, TX Channel Spacing: {ch}")

    def run(self):
        global DEBUG
        sleep(0.5)
        while self.operation_continue[0]:
            if self.print_continue[0] or self.print_continue[1]:
                if not self.free_printed:
                    print(' ' * 150)
                    self.free_printed = True

                if self.rotator_stop > 0:
                    self.rotator_stop -= 1
                else:
                    self.rotate = next(self.rotator)
                    self.rotator_stop = self.max_rotator_stop

                rx_freq, rx_freq_style = self.get_frequency_text('RX')
                rssi, rssi_style = self.get_rssi()
                sq = self.small[RX_SQ]

                r = int((rssi + 120) * self.progressbar_length / 130)
                rssi_progressbar = f"{Fore.LIGHTCYAN_EX}{self.progressbar_fg * r}{Style.RESET_ALL}" \
                                   f"{self.progressbar_bg * (self.progressbar_length - r)}"

                rx_part = self.rx_part.format(rx_freq_style, rx_freq, *self.get_led('RX'), self.stat.get(sq),
                                              rssi_style, rssi, rssi_progressbar)
                if not self.no_tx:
                    tx_freq, tx_freq_style = self.get_frequency_text('TX')

                    ptt, tone = self.small[TX_PTT], self.small[TX_TONE]
                    pwr, pwr_style = self.get_power()
                    mod, mod_style = self.get_mod()
                    swr, swr_style = self.get_swr()

                    tx_part = self.tx_part.format(tx_freq_style, tx_freq, *self.get_led('TX'),
                                                  self.stat.get(ptt or tone),
                                                  pwr_style, pwr, mod_style, mod, swr_style, swr)
                else:
                    tx_part = ''
                tail = self.tail.format(self.get_log_stat(), self.rotate)
                # s = "    " + rx_part + tx_part + tail
                # print(len(s))
                print("    " + rx_part + tx_part + tail, end="")

            else:
                self.free_printed = False

            sleep(self.interval)
            connection_stat = self.get_connection_stat()
            if connection_stat[-1] != self.previous_connection_stat:
                if self.update_connection_stat is not None:
                    self.update_connection_stat(connection_stat)
                    self.previous_connection_stat = connection_stat[-1]

            while not self.from_log.empty():
                obj = self.from_log.get(timeout=1)
                if 'SCPG' not in obj[1]:
                    self.last_log.append(obj)
                while len(self.last_log) > self.last_log_len[0]:
                    self.last_log.pop(0)
            try:
                if DEBUG:
                    self.debug_operation()
            except NameError:
                print('Debug is not defined')
        # print()

