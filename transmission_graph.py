import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from execute import get_connection, get_multiple_row


def get_query(radio, mode='MOD', minute=15):
    return """SELECT [id]
  ,[Radio_Name]
  ,[Date]
  ,[Count]
  ,[Length]
  ,[MOD_Max] as 'Max'
  ,[MOD_Min] as 'Min'
  ,[MOD_Difference] as 'Diff'
  ,[MOD_Mean] as 'Mean'
  ,[MOD_Median] as 'Median'
  ,[MOD_Variance] as 'Var'
  ,[MOD_Deviation] as 'Deviation'
  ,[MOD_Quantiles25] as 'Quantiles25'
  ,[MOD_Quantiles50] as 'Quantiles50'
  ,[MOD_Quantiles75] as 'Quantiles75'
  ,[MOD_Skewness] as 'Skewness'
  ,[MOD_Kurtosis] as 'Kurtosis'
FROM [RCMS].[Analyze].[Transmission]
Where [MOD_Max] is not null
    AND Radio_Name = '{}'
    AND Date >= DATEADD(MINUTE, -{}, GETUTCDATE())
""".replace('MOD', mode).format(radio, minute)


def collect_data(connection, radio, mode='MOD', minute=15):
    query = get_query(radio, mode, minute)
    df = pd.DataFrame(get_multiple_row(connection, query, as_dict=True))
    if len(df) == 0:
        return
    _count = np.sum(df['Count'])
    _length = np.sum(df['Length'])
    _max = np.max(df['Max'])
    _min = np.min(df['Min'])
    _diff = _max - _min
    _mean = np.average(df['Mean'], weights=df['Count'])
    _median = np.average(df['Median'], weights=df['Count'])

    sum_variance = np.sum((df['Count'] - 1) * df['Var'])
    sum_mean_diff = np.sum(df['Count'] * (df['Mean'] - _mean) ** 2)
    _variance = (sum_variance + sum_mean_diff) / (_count - len(df))
    _deviation = np.sqrt(_variance)

    _quantiles25 = np.average(df['Quantiles25'], weights=df['Count'])
    _quantiles50 = np.average(df['Quantiles50'], weights=df['Count'])
    _quantiles75 = np.average(df['Quantiles75'], weights=df['Count'])

    _skewness = np.average(df['Skewness'], weights=df['Count'])
    _kurtosis = np.average(df['Kurtosis'], weights=df['Count'])

    np.random.seed(0)
    data = np.random.normal(loc=_mean, scale=_deviation, size=1000)
    data = pd.Series(data)
    data = data * (1 + _skewness * (data - _mean) / _deviation)
    data = data * (1 + _kurtosis * ((data - _mean) ** 2 - _deviation ** 2) / (_deviation ** 2))
    data = data[(data >= _min) & (data <= _max)]
    return data


def draw_ax(ax, data, name, color):
    if data is not None and len(data):
        ax.hist(data, bins=10, histtype='bar', label=name, rwidth=0.8, alpha=0.5, color=color)
    # ax.set_title(name)
    ax.set_xlabel(f'{name} Value')
    ax.set_ylabel('Frequency')

def draw_histogram(radio, minute):
    _connection = get_connection()
    pwr_data = collect_data(_connection, radio, 'PWR', minute=minute)
    mod_data = collect_data(_connection, radio, 'MOD', minute=minute)
    swr_data = collect_data(_connection, radio, 'SWR', minute=minute)
    exswr_data = collect_data(_connection, radio, 'EXSWR', minute=minute)

    fig, ((tl, tr), (bl, br)) = plt.subplots(nrows=2, ncols=2)
    fig.canvas.manager.set_window_title(f'Transmission Histogram {radio} latest {minute} minutes')

    plt.title(f'Approximate Histogram of {radio} at latest {minute} minutes')
    draw_ax(tl, pwr_data, 'Power', 'g')
    draw_ax(tr, mod_data, 'Modulation', 'b')
    draw_ax(bl, swr_data, 'VSWR', 'r')
    draw_ax(br, exswr_data, 'External VSWR', 'c')

    plt.show()

draw_histogram('ANK_TX_V1M', 15)
