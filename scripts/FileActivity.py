import os
import time
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class WatchdogHandler(FileSystemEventHandler):
    """Logs all the events captured, excluding specified paths."""

    def __init__(self, excluded_paths=None):
        self.excluded_paths = excluded_paths or []

    def should_ignore_event(self, event_path):
        """Check if the event path starts with any of the excluded paths."""
        return any(event_path.startswith(excluded) for excluded in self.excluded_paths)

    def on_modified(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            logging.info(f"File modified: {event.src_path}")

    def on_created(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            logging.info(f"File created: {event.src_path}")

    def on_deleted(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            logging.info(f"File deleted: {event.src_path}")

    def on_moved(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            logging.info(f"File moved from {event.src_path} to {event.dest_path}")

def start_monitoring(paths, excluded_paths=None):
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
    observer = Observer()
    event_handler = WatchdogHandler(excluded_paths)
    for path in paths:
        observer.schedule(event_handler, path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(10)
    except KeyboardInterrupt:
        observer.stop()
        observer.join()

if __name__ == "__main__":
    user_name = os.getenv('USERNAME')
    monitored_paths = [
        f'C:\\Users\\{user_name}\\Documents',
        f'C:\\Users\\{user_name}\\Downloads',
        f'C:\\Users\\{user_name}\\Desktop',
        'C:\\Windows\\System32',
        'C:\\Windows\\SysWOW64'
    ]
    excluded_paths = [
        'C:\\Windows\\System32\\AMD\\EeuDumps\\'
    ]
    start_monitoring(monitored_paths, excluded_paths)
