from execute import get_multiple_row


class Queries:
    def __init__(self, connection, log=None):
        self.log = log
        q = "SELECT code, query FROM Application.Queries"
        self.q = dict(get_multiple_row(connection, q))

    def get(self, key):
        try:
            return self.q[key]
        except KeyError:
            self.log.exception(f'Queries: No Query assigned for "{key}"')


if __name__ == '__main__':
    pass
    # from execute import get_connection
    # _connection = get_connection()
    # queries = Queries(_connection)

