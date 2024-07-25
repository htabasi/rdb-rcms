from base.keeper import BaseKeeper


class Keeper(BaseKeeper):
    def __init__(self, parent, coordinator, name, log):
        super().__init__(parent, name, log)
        self.coordinator = coordinator

    def send_keep_connection(self):
        self.base.ping_counter += 1
        self.kep_packet.add()
        com_num = self.base.command_id
        self.coordinator.send(com_num, 'SCPG', 'S', self.base.ping_timeout)
        self.base.send(f"M:SC {com_num} SPG{self.base.ping_timeout}")
