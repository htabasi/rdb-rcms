class ProgressGenerator:
    def __init__(self):
        self.bar_bg = chr(9617)
        self.bar_fg = chr(9608)
        self.task = ''
        self.task_len, self.current_len, self.progress_len, self.percent_len = 0, 0, 0, 0
        self.max_count = 0
        self.bar, self.partial_bar = "", []
        self.partial = True

    def config(self, task: str, max_count: int, parts_length: list, partial=True):
        self.task = task
        self.task_len, self.current_len, self.progress_len, self.percent_len = parts_length
        self.max_count = max_count
        self.partial = partial
        if partial:
            self.partial_bar = [f"{task:<{self.task_len}}",
                                f"{{:>{self.current_len}}}",
                                f"{{}}",
                                f"{{}}",
                                f"{{:{self.percent_len}}} %"]
        else:
            self.bar = f"\r{task:<{self.task_len}} {{:>{self.current_len}}} {{}}{{}} {{:{self.percent_len}}} %"

    def get_bar(self, current: str, current_index: int):
        fg = self.bar_fg * (current_index * self.progress_len // self.max_count)
        bg = self.bar_bg * ((self.max_count - current_index) * self.progress_len // self.max_count)
        pc = 100 * current_index // self.max_count
        if self.partial:
            return [
                self.partial_bar[0],
                self.partial_bar[1].format(current),
                self.partial_bar[2].format(fg),
                self.partial_bar[3].format(bg),
                self.partial_bar[4].format(pc)
            ]
        else:
            return self.bar.format(current, fg, bg, pc)


if __name__ == '__main__':
    radio_modules = ['ANK_RX_V1M', 'ANK_RX_V1S', 'ANK_RX_V2M', 'ANK_RX_V2S', 'ANK_RX_V3M', 'ANK_RX_V3S', 'ANK_TX_V1M',
                     'ANK_TX_V1S', 'ANK_TX_V2M', 'ANK_TX_V2S', 'ANK_TX_V3M', 'ANK_TX_V3S', 'BJD_RX_V1M', 'BJD_RX_V1S',
                     'BJD_RX_V2M', 'BJD_RX_V2S', 'BJD_RX_V3M', 'BJD_RX_V3S', 'BJD_TX_V1M', 'BJD_TX_V1S', 'BJD_TX_V2M',
                     'BJD_TX_V2S', 'BJD_TX_V3M', 'BJD_TX_V3S', 'BND_RX_V1M', 'BND_RX_V1S', 'BND_RX_V2M', 'BND_RX_V2S',
                     'BND_RX_V3M', 'BND_RX_V3S', 'BND_TX_V1M', 'BND_TX_V1S', 'BND_TX_V2M', 'BND_TX_V2S', 'BND_TX_V3M',
                     'BND_TX_V3S', 'BUZ_RX_V1M', 'BUZ_RX_V1S', 'BUZ_RX_V2M', 'BUZ_RX_V2S', 'BUZ_RX_V3M', 'BUZ_RX_V3S',
                     'BUZ_TX_V1M', 'BUZ_TX_V1S', 'BUZ_TX_V2M', 'BUZ_TX_V2S', 'BUZ_TX_V3M', 'BUZ_TX_V3S', 'ISN_RX_V1M',
                     'ISN_RX_V1S', 'ISN_RX_V2M', 'ISN_RX_V2S', 'ISN_RX_V3M', 'ISN_RX_V3S', 'ISN_TX_V1M', 'ISN_TX_V1S',
                     'ISN_TX_V2M', 'ISN_TX_V2S', 'ISN_TX_V3M', 'ISN_TX_V3S', 'KMS_RX_V1M', 'KMS_RX_V1S', 'KMS_RX_V2M',
                     'KMS_RX_V2S', 'KMS_RX_V3M', 'KMS_RX_V3S', 'KMS_TX_V1M', 'KMS_TX_V1S', 'KMS_TX_V2M', 'KMS_TX_V2S',
                     'KMS_TX_V3M', 'KMS_TX_V3S', 'MSD_RX_V1M', 'MSD_RX_V1S', 'MSD_TX_V1M', 'MSD_TX_V1S', 'TBZ_RX_V1M',
                     'TBZ_RX_V1S', 'TBZ_RX_V2M', 'TBZ_RX_V2S', 'TBZ_RX_V3M', 'TBZ_RX_V3S', 'TBZ_TX_V1M', 'TBZ_TX_V1S',
                     'TBZ_TX_V2M', 'TBZ_TX_V2S', 'TBZ_TX_V3M', 'TBZ_TX_V3S']
    p = ProgressGenerator()
    p.config('Create Radio Modules', len(radio_modules) - 1, [22, 10, 30, 7])
    from time import sleep

    for i, radio in enumerate(radio_modules):
        print(p.get_bar(radio, i), end="")
        sleep(0.2)

    print()
