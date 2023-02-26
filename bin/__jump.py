#!/usr/bin/env python3
# coding: utf-8

import os
import sys
import argparse
from pathlib import Path
from typing import Optional, Tuple, List

def get_args():
    parser = argparse.ArgumentParser(description="Save and print path")
    parser.add_argument('pathmap_path', type=Path)
    parser.add_argument('cmd_key', type=str, nargs='*')
    return parser.parse_args()

def main(args):
    jump = Jump(args.pathmap_path)
    jump(args.cmd_key)
    return 0

class Jump():
    def __init__(self,
                 pathmap_pth: Path
                 ) -> None:
        self.commands = ["add", "rm", "jump", "show"]
        self.pathmap_pth = pathmap_pth
        self.__load_pathmap()
        return

    def __call__(self, cmd_key: List[str]) -> None:
        cmd, key = self.__get_cmd_key(cmd_key)
        if cmd == "add": # add or update
            if key is None: self.__raise_key_none(cmd)
            self.pathmap[key] = Path.cwd()
            self.__save_pathmap()
        elif cmd == "rm": # remove
            if key is None: self.__raise_key_none(cmd)
            if key not in self.pathmap:
                msg = "The key does not exist."
                raise RuntimeError(msg)
            self.pathmap.pop(key)
            self.__save_pathmap()
        elif cmd == "jump": # print (jump)
            if key is None: self.__raise_key_none(cmd)
            print(str(self.pathmap[key]))
        elif cmd == "show": # remove
            self.__show_pathmap()
        return

    def __load_pathmap(self) -> None:
        if not self.pathmap_pth.is_file():
            with self.pathmap_pth.open(mode="w"):
                pass
        self.pathmap = {}
        with self.pathmap_pth.open(mode="r") as ifile:
            lnum = 0
            for line in ifile:
                lnum += 1
                if (lnum % 2) == 1: # lnum is odd.
                    key = line.rstrip()
                else: # lnum is even, line is path.
                    self.pathmap[key] = line.rstrip()
        return

    def __save_pathmap(self) -> None:
        keys = sorted(list(self.pathmap.keys()))
        with self.pathmap_pth.open(mode="w") as ofile:
            for key in keys:
                ofile.write(key + "\n")
                ofile.write(str(self.pathmap[key]) + "\n")
        return

    def __get_cmd_key(self, cmd_key: List[str]) -> Tuple[str, Optional[str]]:
        if len(cmd_key) == 0:
            cmd = "show"
            key = None
        elif len(cmd_key) == 1:
            if cmd_key[0] in self.commands:
                cmd = cmd_key[0]
                key = None
            else:
                cmd = "jump"
                key = cmd_key[0]
        elif len(cmd_key) == 2:
            cmd = cmd_key[0]
            key = cmd_key[1]
        else:
            msg = "Incorrect num of arguments."
            raise RuntimeError(msg)
        return cmd, key

    def __show_pathmap(self) -> None:
        keys = sorted(list(self.pathmap.keys()))
        maxlen = 0
        for key in keys:
            maxlen = max(maxlen, len(key))
        for key in keys:
            print("{0:{1:}}:".format(key, maxlen), self.pathmap[key])
        return

    def __raise_key_none(self, cmd: str):
        msg = f"When command is '{cmd}', key should be given."
        raise RuntimeError(msg)
        return

if __name__ == '__main__':
    args = get_args()
    sys.exit(main(args))
