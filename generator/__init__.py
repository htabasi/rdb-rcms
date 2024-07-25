
def get_file(filename):
    with open(filename, 'r') as f:
        query = f.read()
    return query
