from execute import get_multiple_row


class Queries:
    def __init__(self, parent, connection):
        self.parent = parent
        self.dispatcher = parent.dispatcher
        self.log = None
        q = "SELECT code, query FROM Application.Queries"
        self.q = dict(get_multiple_row(connection, q))

    def get(self, key):
        try:
            return self.q[key]
        except KeyError as e:
            self.log.exception(f'Queries: No Query assigned for "{key}"')
            self.dispatcher.register_message(self.__class__.__name__, e.__class__.__name__, e.args)


if __name__ == '__main__':
    pass
    # from execute import get_connection
    # _connection = get_connection()
    # queries = Queries(_connection)

