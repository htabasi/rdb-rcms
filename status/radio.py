class RadioStatus:
    def __init__(self, name):
        self.name = name
        self.parameters = {}
        self.connection = 0
        self.activation = 0

    def update_status(self, df):
        df = df[(df['Radio_Name'] == self.name)].copy()
        for pid in df['pid'].unique():
            self.parameters[pid] = df[df['pid'] == pid]['severity'].iloc[0]

    def get(self, parameter):
        return self.parameters.get(parameter, 0)

    def __repr__(self):
        return self.name
