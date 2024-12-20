import os

from generator import get_file
from settings import SQL_INSERT_SETTING


class InventoryItem:
    def __init__(self, radio_answer=None, db_answer=None):
        if radio_answer is not None:
            nd = radio_answer.replace('"', '').split(',')
            self.radio_index, self.type, self.variant = int(nd[0]), int(nd[1]), int(nd[5])
            self.component_name, self.ident_number = nd[3:5]
            self.production_index, self.serial_number = nd[7:9]
            self.production_date = nd[9].replace('/', '-')
        else:
            self.radio_index, self.type, self.component_name, self.ident_number, self.variant = db_answer[:5]
            self.production_index, self.serial_number = db_answer[5:7]
            self.production_date = str(db_answer[7])

        self.type_conversion = {0: 'FW', 2: 'SW', 3: 'HWMOD', 4: 'SWMOD', 5: 'DEV'}

    def __eq__(self, other):
        return self.radio_index == other.radio_index and \
            self.type == other.type and \
            self.component_name == other.component_name and \
            self.ident_number == other.ident_number and \
            self.variant == other.variant and \
            self.production_index == other.production_index and \
            self.serial_number == other.serial_number and \
            self.production_date == other.production_date

    def __repr__(self):
        #   0       5       EU4200C RADIO   6144.7800   12      17.00               103897  2015-03-16
        return f"{self.radio_index:^10} {self.type_conversion.get(self.type):^10} {self.component_name:^20} " \
               f"{self.ident_number:^10} {self.variant:^10} {self.production_index:^16} {self.serial_number:^10} " \
               f"{self.production_date:^15}"

    def db_insert(self, dt, name):
        return f"('{dt}', '{name}', {self.radio_index}, {self.type}, '{self.component_name}', '{self.ident_number}', " \
               f"{self.variant}, '{self.production_index}', '{self.serial_number}', '{self.production_date}')"


class Inventory:
    def __init__(self, statement=None):
        self.collection = {}
        self.is_complete = False
        self.statement = statement

    def add_item(self, item: InventoryItem):
        self.collection[item.radio_index] = item
        self.is_complete = len(self.collection) == 10
        # print(f"self.is_complete = {self.is_complete}, len(self.collection) = {len(self.collection)}")

    def clear(self):
        self.collection.clear()
        self.is_complete = False

    def __eq__(self, other):
        if self.__class__.__name__ == other.__class__.__name__:
            return self.collection == other.collection
        else:
            return False

    def __repr__(self):
        s = f"{'Index':^10} {'Type':^10} {'Component':^20} {'Ident':^10} {'Variant':^10} {'Production Index':^16} " \
            f"{'Serial':^10} {'Production Date':^15}"
        for item in sorted(self.collection):
            s += f"\n{self.collection[item]}"
        return s

    def db_insert(self, dt, name):
        if not self.is_complete:
            return
        sql = self.statement
        for item in sorted(self.collection):
            sql += f"{self.collection[item].db_insert(dt, name)}, "
        return sql[:-2] + ';'


class SInventoryInserter:
    def __init__(self, radio, log):
        self.radio = radio.radio
        self.acceptable_keys = ['GRND']
        self.insert = radio.queries.get('ISInventory')
        p = self.insert.index('VALUES') + 7
        self.statement, self.values = self.insert[:p], self.insert[p:-1]
        self.db_inventory = None
        self.inventory = Inventory(self.statement)
        self.log = log

    def save_inventory(self, db_inventory):
        self.log.debug(f"{self.__class__.__name__}: Inventory received from database")
        if db_inventory is not None:
            if len(db_inventory) != 10:
                self.log.debug(f"{self.__class__.__name__}: Error in Inventory Read from database! "
                               f"len(db_inventory)={len(db_inventory)}, db_inventory={db_inventory}")
                return
            self.db_inventory = Inventory(self.statement)
            for item in db_inventory:
                self.db_inventory.add_item(InventoryItem(db_answer=item[3:]))
            self.log.debug(f"{self.__class__.__name__}: Inventory saved")

    def clear(self):
        self.inventory.clear()
        self.log.debug(f"{self.__class__.__name__}: Inventory cleared")

    def generate(self, time_tag, key, value):
        self.inventory.add_item(InventoryItem(radio_answer=value))
        self.log.debug(f"{self.__class__.__name__}: Adding Next item: {value}")
        if self.inventory.is_complete:
            # self.log.debug(f"{self.__class__.__name__}: {len(self.inventory.collection)} Items Collected")
            # self.log.debug(f"{self.__class__.__name__}: db_inventory and new inventory are same is {self.inventory
            # == self.db_inventory} ")
            if self.inventory != self.db_inventory:
                query_list = [self.inventory.db_insert(str(time_tag)[:23], self.radio.name)]
                self.db_inventory = self.inventory
                self.inventory = Inventory(self.statement)
                self.log.debug(f"{self.__class__.__name__}: Query Generated")
                # self.log.debug(f"{self.__class__.__name__}: Generation Result: {query_list}")
                return query_list
            else:
                # self.log.debug(f"{self.__class__.__name__}: No Query Generated")
                return []
        else:
            # self.log.debug(f"{self.__class__.__name__}: No Query Generated")
            return []
