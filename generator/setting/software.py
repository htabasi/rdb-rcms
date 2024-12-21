class Partition:
    def __init__(self, version=None, part_number=None, db_answer=None):
        """
        Partition Status:
            0: Booted
            1: Ready
            2: Update
        """
        if db_answer is None:
            self.version = version
            self.part_number = part_number
            if self.version == '00.00' and self.part_number == '0000.0000.00':
                self.status = 2
            else:
                self.status = 1
        else:
            self.version, self.part_number, self.status = db_answer

        self.convert_status = {0: 'Booted', 1: 'Ready', 2: 'Update'}

    def set_booted(self):
        self.status = 0

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.version == other.version and \
                self.part_number == other.part_number and \
                self.status == other.status

    def __repr__(self):
        return f"Part_Number = {self.part_number}, Version = {self.version}, " \
               f"Status = {self.convert_status.get(self.status)}"

    def db_insert(self):
        return f"'{self.part_number}', '{self.version}', {self.status}"


class Software:
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            booted, v1, p1, v2, p2 = radio_answer.replace('"', '').split(',')[1:]
            self.partitions = [Partition(v1, p1), Partition(v2, p2)]
            self.booted = int(booted)
            self.partitions[self.booted - 1].set_booted()
        else:
            # [(1, '11.05', '6164.6921.05', 0), (2, '00.00', '0000.0000.00', 2)]
            self.partitions = [Partition(db_answer=p[1:]) for p in db_answer]
            if self.partitions[0].status == 0:
                self.booted = 1
            elif self.partitions[1].status == 0:
                self.booted = 2

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.partitions[0] == other.partitions[0] and \
                self.partitions[1] == other.partitions[1] and \
                self.booted == other.booted

    def __repr__(self):
        return f"Partition {1}: {self.partitions[0]}\nPartition {2}: {self.partitions[1]}"

    def db_insert(self, partition):
        return f"{partition}, {self.partitions[partition - 1].db_insert()}"


class SSoftwareInserter:
    def __init__(self, radio, log):
        self.radio = radio.radio
        self.insert = radio.queries.get('ISSoftware')
        self.acceptable_keys = ['GRSV']
        self.db_software = None
        self.log = log

    def save_software(self, db_software):
        # self.log.debug(f"{self.__class__.__name__}: Software version received")
        if db_software is not None:
            self.db_software = Software(db_answer=db_software)

    def generate(self, time_tag, key, value):
        # self.log.debug(f"{self.__class__.__name__}: {key} received")
        software = Software(radio_answer=value)
        if software != self.db_software:
            self.db_software = software
            return [self.insert.format(time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name,
                                       software.db_insert(1),
                                       time_tag.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], self.radio.name,
                                       software.db_insert(2))]
        else:
            return []
