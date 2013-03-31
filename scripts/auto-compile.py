import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from watchdog.events import LoggingEventHandler
import sys
import os.path

def recompile():
    #print 'Recompile needed!'
    #sys.stdout.flush()
    subprocess.check_call('./compile')

class EventHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory:
            recompile()

    def on_deleted(self, event):
        if not event.is_directory:
            recompile()

    def on_modified(self, event):
        if not event.is_directory:
            recompile()

    def on_moved(self):
        recompile()

def main():
    event_handler = EventHandler()
    #event_handler = LoggingEventHandler()
    observer = Observer()
    observer.schedule(event_handler,
                      path = os.path.realpath('src/coffee'),
                      recursive = True)
    observer.schedule(event_handler,
                      path = os.path.realpath('compile'))
    observer.start()
    try:
        while True:
            time.sleep(5)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == '__main__':
    main()

