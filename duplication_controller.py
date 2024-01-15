import os
import sys


class Controller:
    def __init__(self, filepath, name='', force=False):
        self.path = filepath
        self.name = name
        self.allow = False
        self.clear_content = False
        try:
            self.controller = open(self.path, 'r')
        except FileNotFoundError:
            self.allow = True
        else:
            try:
                content = self.controller.read()
            except (PermissionError, IOError, OSError) as e:
                self.controller.close()
                return
            else:
                self.controller.close()
                if len(content) > 0:
                    try:
                        previous_pid = int(content)
                    except ValueError:
                        self.warn()
                        if force:
                            self.allow = self.clear_content = True
                        else:
                            return
                    else:
                        import psutil
                        if psutil.pid_exists(previous_pid):
                            self.warn(previous_pid)
                            return
                        else:
                            self.warn(previous_pid, problem=True)
                            self.allow = self.clear_content = True
                else:
                    self.allow = True

        self.controller = open(self.path, 'a')
        if self.clear_content:
            self.clear()
        self.lock()

    def lock(self):
        pid = os.getpid()
        self.controller.write(f"{pid}")
        self.controller.flush()
        self.controller.seek(0)
        if sys.platform != 'win32':
            import fcntl
            fcntl.flock(self.controller.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        else:
            import msvcrt
            msvcrt.locking(self.controller.fileno(), msvcrt.LK_LOCK, os.path.getsize(self.path))

    def unlock(self):
        if sys.platform != 'win32':
            import fcntl
            fcntl.flock(self.controller.fileno(), fcntl.LOCK_UN)
        else:
            import msvcrt
            msvcrt.locking(self.controller.fileno(), msvcrt.LK_UNLCK, os.path.getsize(self.path))
        self.clear()
        self.controller.close()

    def warn(self, pid=None, problem=False):
        if problem:
            print(f'Warning: Previous {self.name} Module with pid={pid} is not closed successfully.')
        elif pid is not None:
            print(f'Warning: Another {self.name} Module with pid={pid} is running.')
        else:
            print(f'Warning: Another {self.name} Module with unknown pid is running.')

    def clear(self):
        self.controller.seek(0)
        self.controller.truncate()


if __name__ == '__main__':
    controller = Controller('temp/.controller', force=True)

    if controller.allow:
        print('I am allowed!')

        from time import sleep
        for i in range(1, 14):
            print(i)
            sleep(1.5)

        controller.unlock()
    else:
        print('I am NOT allowed!')
