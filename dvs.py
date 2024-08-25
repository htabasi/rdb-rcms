from generator.health import HealthMonitor


def dev_score(a, o, c):
    return a + 2 * o + 4 * c


score = {dev_score(act, opr, acc): (act, opr, acc) for act in [0, 1] for opr in [0, 1] for acc in [0, 1, 2]}

# for k in sorted(score.keys()):
#     print(k, ':', score[k])

if __name__ == '__main__':
    from execute import get_connection, get_multiple_row, get_file
    connection = get_connection()
    fvt = get_multiple_row(connection, get_file('sql/prepare/health/fixed_value.sql').format('BUZ_RX_V1M'), as_dict=True)
    mlt = get_multiple_row(connection, get_file('sql/prepare/health/multi_level.sql').format('BUZ_RX_V1M'), as_dict=True)
    rst = get_multiple_row(connection, get_file('sql/prepare/health/range.sql').format('BUZ_RX_V1M'), as_dict=True)
    est = get_multiple_row(connection, get_file('sql/prepare/health/equal_string.sql').format('BUZ_RX_V1M'), as_dict=True)
    pst = get_multiple_row(connection, get_file('sql/prepare/health/pattern_string.sql').format('BUZ_RX_V1M'), as_dict=True)

    hm = HealthMonitor()
    print(fvt)
    print(mlt)
    print(rst)
    print(est)
    print(pst)

    hm.create_parameters(fvt, mlt, rst, est, pst)

    # exit()
    print(hm.health)

    hm.add('Frequency', 120700000)
    hm.add('Connection', 0)
    # hm.add('Carrier Offset', '+7.5')
    hm.add('NTPSyncActive', 1)
    hm.add('CBITLevel', 2)
    hm.add('Session', 1)
    hm.add('Access', 5)

    hm.add('AudioDelay', 0)
    # hm.add('SWR', 0)
    # hm.add('Noise Level', -115)
    # hm.add('Modulation', 0)
    # hm.add('Power', 0)

    print('=' * 20)
    print(hm.health)
    hm.add('Frequency', 132500000)
    hm.add('Connection', 1)
    # hm.add('Carrier Offset', 'Off')
    hm.add('NTPSyncActive', 0)
    hm.add('CBITLevel', 0)
    hm.add('Session', 2)
    hm.add('Access', 0)

    hm.add('AudioDelay', 5)
    # hm.add('SWR', 1.7)
    # hm.add('Noise Level', -90)
    # hm.add('Modulation', 30)
    # hm.add('Power', 47)

    print('=' * 20)
    print(hm.health)
    hm.add('Frequency', 120700000)
    hm.add('Connection', 1)
    # hm.add('Carrier Offset', '+7.5')
    hm.add('NTPSyncActive', 0)
    hm.add('CBITLevel', 1)
    hm.add('Session', 4)
    hm.add('Access', 1)

    hm.add('AudioDelay', 75)
    # hm.add('SWR', 26)
    # hm.add('Noise Level', -101)
    # hm.add('Modulation', 85)
    # hm.add('Power', 50)

    print('=' * 20)
    print(hm.health)

    # hm.add('Modulation', 95)
    # hm.add('Power', 60)
    # print('=' * 20)
    # print(hm.health)
    #
    # hm.add('Modulation', 200)
    # hm.add('Power', 40)
    # print('=' * 20)
    # print(hm.health)

