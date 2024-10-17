import matplotlib.pyplot as plt
import pickle
import pandas as pd

# باز کردن فایل pickle
with open('export/status_reloading_time.pkl', 'rb') as f:
    df = pickle.load(f)

print(df)
print(df['FrequencyReloading'].mean())
print(df['ParameterReloading'].mean())
print(df['StatusFetching'].mean())
print(df['StatusUpdating'].mean())

df.loc[:, 'FrequencyReloading'] = df['FrequencyReloading'].ffill()
df.loc[:, 'ParameterReloading'] = df['ParameterReloading'].ffill()

# رسم گراف
plt.figure(figsize=(10, 6))

plt.plot(df['Date'], df['FrequencyReloading'], label='FrequencyReloading')
plt.plot(df['Date'], df['ParameterReloading'], label='ParameterReloading')
plt.plot(df['Date'], df['StatusFetching'], label='StatusFetching')
plt.plot(df['Date'], df['StatusUpdating'], label='StatusUpdating')

plt.xlabel('Timestamp')
plt.ylabel('Values')
plt.title('Parameters Over Time')
plt.legend()
plt.grid(True)
plt.show()



# #
# # q ="""
# # SELECT HPA.id            as 'id',
# #        HPA.ParameterCode as 'code',
# #        CKI.CKey          as 'key',
# #        HPA.ParameterName as 'name',
# #        R.Enable          as 'enable',
# #        R.start           as 'start',
# #        R.[end]           as 'end',
# #        HME.message       as 'normal_msg',
# #        RS.range_start    as 'r_start',
# #        RS.range_end      as 'r_end',
# #        RS.severity       as 'severity',
# #        HMS.message       as 'message'
# # FROM HealthMonitor.Parameters HPA
# #          INNER JOIN HealthMonitor.Range R ON HPA.id = R.ParameterID
# #          INNER JOIN HealthMonitor.Messages HME ON R.normal_msg = HME.id
# #          INNER JOIN HealthMonitor.RangeStats RS on R.id = RS.RangeID
# #          INNER JOIN HealthMonitor.Messages HMS ON RS.message = HMS.id
# #          INNER JOIN Command.KeyInformation CKI ON HPA.[Key] = CKI.id
# # Where R.Enable = 1
# #   AND Radio_Name = '{}';"""
# #
# #
# # if __name__ == '__main__':
# #     from execute import get_connection, get_multiple_row, get_file
# #     connection = get_connection()
# #     answer = get_multiple_row(connection, q.format('ANK_TX_V1M'), as_dict=True)
# #     print(len(answer))
# #     print(answer)
# #     print(type(answer[0]['enable']), answer[0]['enable'])
# from time import sleep
#
# from status.status import run
# from multiprocessing import Process
#
#
# if __name__ == '__main__':
#     p = Process(target=run, args=())
#     p.start()
#     while p.is_alive():
#         p.join(3)
#         if p.is_alive():
#             print(f'Updater is working updater.is_alive()={p.is_alive()}')
#             sleep(2)
#
#     p.join()
#
# # import datetime
# #
# # transmissions = list(LatestTransmission.objects.filter(radio_name__id=radio_id,
# #                                                        rcmo__isnull=False,
# #                                                        date__gte=time_limit
# #                                                        ).order_by('-date').values('date', 'rcmo'))
# # last_rcmo = LatestTransmission.objects.filter(radio_name__id=radio_id,
# #                                               rcmo__isnull=False
# #                                               ).order_by('-date').values('date', 'rcmo').first()
# # if last_rcmo is not None:
# #     now_date = datetime.datetime.now(datetime.UTC)
# #     if len(transmissions) == 0:
# #         transmissions.extend(
# #             [{'date': now_date - datetime.timedelta(minutes=1), 'rcmo': last_rcmo['rcmo']},
# #              {'date': now_date, 'rcmo': last_rcmo['rcmo']}])
# #     else:
# #         transmissions.append({'date': now_date, 'rcmo': last_rcmo['rcmo']})
#
#
#
# #
# # import pandas as pd
# #
# # # داده‌های نمونه
# # fp = [
# #     {'TXM': 0, 'TXS': 0, 'RXM': 0, 'RXS': 0, 'Level': 0},
# #     {'TXM': 0, 'TXS': 0, 'RXM': 0, 'RXS': 1, 'Level': 2},
# #     {'TXM': 0, 'TXS': 0, 'RXM': 1, 'RXS': 0, 'Level': 2},
# #     {'TXM': 0, 'TXS': 0, 'RXM': 1, 'RXS': 1, 'Level': 3},
# #     {'TXM': 0, 'TXS': 1, 'RXM': 0, 'RXS': 0, 'Level': 2},
# #     {'TXM': 0, 'TXS': 1, 'RXM': 0, 'RXS': 1, 'Level': 2},
# #     {'TXM': 0, 'TXS': 1, 'RXM': 1, 'RXS': 0, 'Level': 2}
# # ]
# #
# # # تبدیل لیست دیکشنری‌ها به دیتافریم
# # df = pd.DataFrame(fp)
# # columns_to_convert = ['TXM', 'TXS', 'RXM', 'RXS', 'Level']
# # df[columns_to_convert] = df[columns_to_convert].astype('uint8')
# # # ایجاد دیکشنری تو در تو
# # nested_dict = {}
# # for _, row in df.iterrows():
# #     nested_dict.setdefault(row['TXM'], {}).setdefault(row['TXS'], {}).setdefault(row['RXM'], {})[row['RXS']] = row['Level']
# #
# # print(nested_dict)
# #
# # # تابع برای پیدا کردن مقدار Level بر اساس مقادیر TXM, TXS, RXM, RXS
# # def get_level(txm, txs, rxm, rxs):
# #     return nested_dict.get(txm, {}).get(txs, {}).get(rxm, {}).get(rxs, None)
# #
# # # مثال استفاده از تابع
# # print(get_level(0, 1, 1, 0))  # خروجی: 2
# # print(get_level(0, 0, 1, 1))  # خروجی: 3
