class Aggregator:
    def __init__(self, db_field: str, value_type=int):
        self.db_field = db_field
        self.type = value_type
        self.base_value = value_type(0)

        self.agg = self.base_value
        self.res = self.base_value

    def add(self, n=1):
        self.agg += n
        self.res += n

    def reset(self):
        self.res = self.base_value

    def set(self, aggregate: dict, resettable: dict):
        self.agg += self.type(aggregate[self.db_field])
        self.res += self.type(resettable[self.db_field])

    def update(self):
        return f"{self.db_field}={self.agg}, "

    def update_res(self):
        return f"{self.db_field}={self.res}, "


class OperatingHourUpdater:
    def __init__(self, db_field: str):
        self.db_field = db_field
        self.cnt = self.cnt_res = 0

    def set(self, aggregate: dict, resettable: dict):
        self.cnt = aggregate[self.db_field]
        self.cnt_res = resettable[self.db_field]

    def add(self, n):
        self.cnt = self.cnt_res = n

    def update(self):
        return f"{self.db_field}={self.cnt}, "

    def update_res(self):
        return f"{self.db_field}={self.cnt_res}, "
