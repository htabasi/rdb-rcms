from threading import Thread
from time import sleep, time
import numpy as np


class RXAnalyzer:
    pass


class TXAnalyzer:
    pass


TIME_SHIFT = time()


class RXSimulator(Thread):
    def __init__(self):
        super().__init__(name=f'RX_Simulator_Thread', daemon=True)
        self.rssi = {'noise': [], 'pilot': [], 'controller': []}
        self.generator_interval = 0
        self.hysteresis = 5
        self.previous_sq = -1
        self.noise_mean, self.noise_sigma = -110, 4
        self.pilot_mean = -80

        self.noise = (self.noise_mean, self.noise_sigma)
        self.pilot = (self.pilot_mean, 30)
        self.pilot_noise = (0, 1)
        self.controller = (-10, 1)
        self.controller_noise = (0, 1)
        self.choice_time = (3, 2)
        self.choices = list(range(100))
        self.pilot_choice = list(range(15))
        self.controller_choice = list(range(15, 30))

        self.NOISE, self.CONTROLLER, self.PILOT = 0, 1, 2
        self.cnv = {0: 'NOISE', 1: 'CONTROLLER', 2: 'PILOT'}

    @staticmethod
    def uv(dbm):
        return np.sqrt(5 * 10 ** (dbm / 10 + 10))

    @staticmethod
    def dbm(uv):
        return 20 * np.log10(np.abs(uv))
        # ans = -106.98970004336019 + 20 * np.log10(np.abs(uv))
        # ans = 20 * np.log10(np.abs(uv))
        # print(f'{uv * 10**6:7.4} uv >>> {ans:7.5} dbm')
        # return ans

    @staticmethod
    def generator(mu, sigma, int_true=True):
        # sleep(1)
        while True:
            if int_true:
                yield int(np.random.normal(mu, np.sqrt(sigma)))
            else:
                yield np.random.normal(mu, np.sqrt(sigma))

    def dbm_generator(self, mu, sigma):
        volt = self.uv(mu)
        print(volt, sigma)
        # sleep(1)
        while True:
            yield self.dbm(np.random.normal(volt, sigma))

    def noise_generator(self, noise_power_dbm, mean_noise=0):
        noise_power_watt = 10 ** (noise_power_dbm / 10)
        print(noise_power_dbm, noise_power_watt)

        while True:
            noise_volt = np.random.normal(mean_noise, np.sqrt(noise_power_watt))
            yield self.dbm(noise_volt)

    @staticmethod
    def choice_generator(min_value, max_value):
        from random import choice, shuffle
        # sleep(1)
        data = list(range(min_value, max_value))
        shuffle(data)
        while True:
            yield choice(data)

    def turn_select(self, min_value, max_value, n=0.50, c=0.17):
        selection = iter(self.choice_generator(min_value, max_value))
        N, C = int(100 * n), int(100 * c)
        while True:
            turn = next(selection)
            if turn >= N:
                yield self.NOISE
            elif turn >= C:
                yield self.CONTROLLER
            else:
                yield self.PILOT

    def get_length(self, turn):
        if turn == self.NOISE:
            return next(self.noise_length)
        elif turn == self.CONTROLLER:
            return next(self.controller_length)
        else:
            return next(self.pilot_length)

    def get_value(self, turn):
        if turn == self.NOISE:
            return next(self.noise_level)
        elif turn == self.CONTROLLER:
            return next(self.controller_level)
        else:
            return next(self.pilot_level)

    def test(self, generator):
        start = time()
        c = 0
        while True:
            c += 1
            print(f'Generate {c} : {next(generator)}')
            if time() - start > 15:
                break
            sleep(0.5)

    def test_count(self, generator):
        start = time()
        c = 0
        count = {}
        while True:
            c += 1
            g = next(generator)
            # print(f'Generate {c} : {g}')
            if g in count:
                count[g] += 1
            else:
                count[g] = 1
            if time() - start > 3:
                break
            # sleep(0.5)
        s = sum(list(count.values()))
        for g in [0, 1, 2]:
            print(f"{g} : repeated {count[g]} = {100 * count[g] / s: 7.5} %")

    def run(self):
        """
        Should be generated:
            Noise level         =>      normal(-110, 4)
            pilot level         =>      choice(-110<?<-60)
            Controller level    =>      choice(-20<?<-15)
            pilot length        =>      normal(10, 10) second
            controller length   =>      normal(10, 7) second
            generator interval  =>      normal(0.3, 0.1) second

            Pilot probability   =>      0.17
            controller probability =>   0.33
            noise probability   =>      0.50

        """

        # self.noise_level = iter(self.dbm_generator(-110, 4))
        self.noise_level = iter(self.noise_generator(-130, 0))
        self.pilot_level = iter(self.choice_generator(-110, -60))
        self.controller_level = iter(self.choice_generator(-20, -15))
        self.turn = iter(self.turn_select(0, 100, n=0.5, c=0.17))

        self.pilot_length = iter(self.generator(10, 10, int_true=False))
        self.controller_length = iter(self.generator(10, 7, int_true=False))
        self.noise_length = iter(self.generator(20, 30, int_true=False))

        self.generator_interval = iter(self.generator(0.35, 0.001, int_true=False))
        # self.test(self.generator_interval)
        start = time()
        while True:
            turn_start_time = time()
            turn = next(self.turn)
            length = {self.NOISE: next(self.noise_length),
                      self.CONTROLLER: next(self.controller_length),
                      self.PILOT: next(self.pilot_length)}.get(turn)

            if turn == self.CONTROLLER:
                controller_level = next(self.controller_level)
                pilot_level = 0
            elif turn == self.PILOT:
                controller_level = 0
                pilot_level = next(self.pilot_level)
            else:
                controller_level = 0
                pilot_level = 0
            # length = self.get_length(turn)

            while time() - turn_start_time < length:
                # rssi = self.get_value(turn)
                rssi = controller_level + pilot_level - next(self.noise_level)

                print(f"{self.cnv.get(turn):^12}: {rssi: 7.5}")

                sleep(next(self.generator_interval))

            if time() - start > 60:
                break

    @staticmethod
    def get_time(floating_digit=1):
        p = 10 ** floating_digit
        return int(p * (time() - TIME_SHIFT)) / p

    def choice_length_generator(self, mu, sigma):
        sleep(1)
        while True:
            n = np.random.normal(mu, sigma)
            if n < 0.1:
                n = mu - n
            yield n

    def print_rssi(self):
        def get_next(key, i):
            try:
                return self.rssi[key][i]
            except IndexError:
                return '*'

        print(f"{'Noise':^10} | {'Controller':^10} | {'Pilot':^10}")
        print("-" * 30)
        for i in range(100):
            nr, cr, pr = get_next('noise', i), get_next('controller', i), get_next('pilot', i)
            print(f"{nr:^10} | {cr:^10} | {pr:^10}")
        print("-" * 30)
        print(f"{len(self.rssi['noise']):^10} | {len(self.rssi['controller']):^10} | {len(self.rssi['pilot']):^10}")


if __name__ == '__main__':
    rx = RXSimulator()
    rx.start()
    rx.join()
    # l = []
    # n = 100
    # # for i in range(2, n + 1):
    # #     x = 0
    # #     for j in range(1, i + 1):
    # #         if i % j == 0:
    # #             x += 1
    # #     if x == 2:
    # #         l.append(i)
    # # print(l)
    #
    # def is_prime(i):
    #     for j in range(2, int(math.sqrt(i) + 1)):
    #         if i % j == 0:
    #             return False
    #     return True
    #
    # l = [2]
    # import math
    # for i in range(3, n + 1, 2):
    #     # is_prime = True
    #     # for j in range(2, int(math.sqrt(i) + 1)):
    #     #     if i % j == 0:
    #     #         is_prime = False
    #     #         break
    #     # if is_prime:
    #     #     l.append(i)
    #     if is_prime(i):
    #         l.append(i)
    #
    # print(l)
    # n = int(input("Please Enter a Number:"))
    # if is_prime(n):
    #     print(f"{n} is prime")
    # else:
    #     print(f"{n} is NOT prime")

