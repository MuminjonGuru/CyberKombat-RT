import os
import time
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class WatchdogHandler(FileSystemEventHandler):
    """Enhanced handler to log events and detect suspicious activities."""
    def __init__(self, excluded_paths=None, critical_files=None, suspicious_extensions=None):
        self.excluded_paths = excluded_paths or []
        self.critical_files = critical_files or []
        self.suspicious_extensions = suspicious_extensions or ['.exe', '.bat', '.cmd', '.ps1', '.vbs']

    def should_ignore_event(self, event_path):
        """Check if the event path starts with any of the excluded paths."""
        return any(event_path.startswith(excluded) for excluded in self.excluded_paths)

    def is_suspicious_file(self, path):
        """Check if file has a suspicious extension or is a critical system file."""
        return any(path.endswith(ext) for ext in self.suspicious_extensions) or path in self.critical_files

    def log_event(self, action, path):
        """Log the event with specific details."""
        if self.is_suspicious_file(path):
            logging.warning(f"Suspicious {action}: {path}")
        else:
            logging.info(f"{action}: {path}")

    def on_modified(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            self.log_event('File modified', event.src_path)

    def on_created(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            self.log_event('File created', event.src_path)

    def on_deleted(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            self.log_event('File deleted', event.src_path)

    def on_moved(self, event):
        if not event.is_directory and not self.should_ignore_event(event.src_path):
            self.log_event('File moved', f"{event.src_path} to {event.dest_path}")

def start_monitoring(paths, excluded_paths=None):
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
    observer = Observer()
    critical_files = ['C:\\Windows\\system32\\config\\SAM']
    event_handler = WatchdogHandler(excluded_paths, critical_files=critical_files)
    for path in paths:
        observer.schedule(event_handler, path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(2)
    except KeyboardInterrupt:
        observer.stop()
        observer.join()

if __name__ == "__main__":
    user_name = os.getenv('USERNAME')
    monitored_paths = [
        f'C:\\Users\\{user_name}\\Documents',
        f'C:\\Users\\{user_name}\\Downloads',
        f'C:\\Users\\{user_name}\\Desktop',
        f'C:\\Users\\{user_name}\\AppData',
        f'C:\\Windows\\Temp',
        f'C:\\Users\\{user_name}\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup',
        'C:\\Windows\\System32',
        'C:\\Windows\\SysWOW64',
        'C:\\Program Files',
        'C:\\Program Files (x86)',
        'C:\\ProgramData'
    ]
    excluded_paths = [
        'C:\\Windows\\System32\\AMD\\EeuDumps\\'
    ]
    start_monitoring(monitored_paths, excluded_paths)
