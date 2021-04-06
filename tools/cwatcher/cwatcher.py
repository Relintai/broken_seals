import sys
import time
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import json
import os
import subprocess
import shutil
import traceback

class CWEventHandler(FileSystemEventHandler):
    compile_commands = {}
    modified_files = {}

    """Logs all the events captured."""

    def __init__(self, logger=None):
        super().__init__()

        self.logger = logger or logging.root

        self.load_compile_commands()


    def load_compile_commands(self):
        self.compile_commands = {}

        data = 0
        with open('compile_commands.json') as f:
            data = json.load(f)

        for d in data:
            key = "./" + d["file"]
            command = d["command"]

            self.compile_commands[key] = command

    def recompile(self):
        mf = self.modified_files
        self.modified_files = {}

        print("Compiling...")

        for key in mf.keys():
            print("Compiling " + key)

            subprocess.call(self.compile_commands[key], shell=True)

        #test
        subprocess.call("g++ -o bin/godot.x11.opt.tools.64 -pipe -no-pie -static-libgcc -static-libstdc++ platform/x11/godot_x11.x11.opt.tools.64.o platform/x11/context_gl_x11.x11.opt.tools.64.o platform/x11/crash_handler_x11.x11.opt.tools.64.o platform/x11/os_x11.x11.opt.tools.64.o platform/x11/key_mapping_x11.x11.opt.tools.64.o platform/x11/joypad_linux.x11.opt.tools.64.o platform/x11/power_x11.x11.opt.tools.64.o platform/x11/detect_prime.x11.opt.tools.64.o platform/x11/libudev-so_wrap.x11.opt.tools.64.o main/libmain.x11.opt.tools.64.a main/tests/libtests.x11.opt.tools.64.a modules/libmodules.x11.opt.tools.64.a platform/libplatform.x11.opt.tools.64.a drivers/libdrivers.x11.opt.tools.64.a editor/libeditor.x11.opt.tools.64.a scene/libscene.x11.opt.tools.64.a servers/libservers.x11.opt.tools.64.a core/libcore.x11.opt.tools.64.a modules/freetype/libfreetype_builtin.x11.opt.tools.64.a -lXcursor -lXinerama -lXext -lXrandr -lXrender -lX11 -lXi -lGL -lpthread -ldl", shell=True)
        

    def on_moved(self, event):
        super().on_moved(event)

        what = 'directory' if event.is_directory else 'file'
        self.logger.info("Moved %s: from %s to %s. You will probably need to re-run a scons compile.", what, event.src_path, event.dest_path)

    def on_created(self, event):
        super().on_created(event)

        if not event.is_directory and event.src_path.endswith(".o"):
            return


        what = 'directory' if event.is_directory else 'file'
        self.logger.info("Created %s: %s. You will probably need to re-run a scons compile.", what, event.src_path)

    def on_deleted(self, event):
        super().on_deleted(event)

        if not event.is_directory and event.src_path.endswith(".o"):
            return

        what = 'directory' if event.is_directory else 'file'
        self.logger.info("Deleted %s: %s. You will probably need to re-run a scons compile.", what, event.src_path)

    def on_modified(self, event):
        super().on_modified(event)

        if (event.is_directory):
            return

        if event.src_path in self.compile_commands:
            self.logger.info("Modified file: %s", event.src_path)
            self.modified_files[event.src_path] = 1


def generate_sub_moved_events(src_dir_path, dest_dir_path):
    """Generates an event list of :class:`DirMovedEvent` and
    :class:`FileMovedEvent` objects for all the files and directories within
    the given moved directory that were moved along with the directory.
    :param src_dir_path:
        The source path of the moved directory.
    :param dest_dir_path:
        The destination path of the moved directory.
    :returns:
        An iterable of file system events of type :class:`DirMovedEvent` and
        :class:`FileMovedEvent`.
    """
    for root, directories, filenames in os.walk(dest_dir_path):
        for directory in directories:
            full_path = os.path.join(root, directory)
            renamed_path = full_path.replace(dest_dir_path, src_dir_path) if src_dir_path else None
            event = DirMovedEvent(renamed_path, full_path)
            event.is_synthetic = True
            yield event
        for filename in filenames:
            full_path = os.path.join(root, filename)
            renamed_path = full_path.replace(dest_dir_path, src_dir_path) if src_dir_path else None
            event = FileMovedEvent(renamed_path, full_path)
            event.is_synthetic = True
            yield event



if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(message)s',
                        datefmt='%Y-%m-%d %H:%M:%S')

    path = sys.argv[1] if len(sys.argv) > 1 else '../../engine/'

    cwd = os.getcwd()
    full_path = os.path.abspath(path)

    
    if not os.path.isdir(full_path):
        print("Invalid path supplied!")

    os.chdir(full_path)

    if not os.path.exists('compile_commands.json'):
        print("No compile_commands.json found in the given path.")

    event_handler = CWEventHandler()

    observer = Observer()
    observer.schedule(event_handler, ".", recursive=True)
    observer.start()

    try:
        while True:
            #time.sleep(1)
            inp = input()

            if inp == "c":
                event_handler.recompile()
            elif inp == "q":
                break
    except KeyboardInterrupt:
        pass
    
    observer.stop()
    observer.join()

