#!/usr/bin/env python3
# coding: utf-8

import os
import argparse
from pathlib import Path

def get_sortkeys(pathmap):
    keylist = list(pathmap.keys())
    keylist.sort()
    return keylist

# cmd functions
def add_key(pathmap, key):
    pathmap[key] = Path.cwd()

def remove_key(pathmap, key):
    pathmap.pop(key)

def show_path(pathmap, key):
    print(pathmap[key])

def show_file(pathmap):
    keys = get_sortkeys(pathmap)
    maxlen = 0
    for key in keys:
        maxlen = max(maxlen, len(key))
    for key in keys:
        print("{0:{1:}}:".format(key, maxlen), pathmap[key])

def output_help():
    with open(HELP_PATH, 'r') as ihelp:
        for line in ihelp:
            print(line.splitlines()[0])

# save load file
def load_file(pathmap_path):
    pathmap = {}
    with open(pathmap_path, 'r') as ifile:
        lnum = 0
        for line in ifile:
            lnum += 1
            if (lnum % 2) == 1: # lnum is odd.
                key = line.splitlines()[0]
            else: # lnum is even, line is path.
                pathmap[key] = line.splitlines()[0]
    return pathmap

def save_file(pathmap_path, pathmap):
    keys = get_sortkeys(pathmap)
    with open(pathmap_path, 'w') as ofile:
        for key in keys:
            ofile.write(key + "\n")
            ofile.write(pathmap[key] + "\n")

# is exist
def is_cmd_exist(incmd):
    cmdlist = list(CMDS.keys())
    if incmd in cmdlist:
        return True
    return False

def is_cmd_exist_nokey(incmd):
    cmdlist = list(CMDS.keys())
    if (incmd in cmdlist) and ("nokey" in CMDS[incmd][1]):
        return True
    return False

# arg
def get_cmd_key(cmd_key_list):
    key = ""
    if len(cmd_key_list) == 0:
        cmd = "show"
    elif len(cmd_key_list) == 1 and is_cmd_exist_nokey(cmd_key_list[0]):
        cmd = cmd_key_list[0]
    elif len(cmd_key_list) == 1:
        cmd = "jump"
        key = cmd_key_list[0]
    else # len(cmd_key_list) == 2
        cmd = cmd_key_list[0]
        key = cmd_key_list[1]
    if not is_cmd_exist(cmd):
        msg = "Given command does not implemented."
        raise ValueError(msg)
    if not is_cmd_exist_nokey(key):
        msg = "Givn key cannot be used."
        raise ValueError(msg)
    return cmd, key

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('pathmap_path', type=Path)
    parser.add_argument('cmd_key_list', type=str, nargs='*')
    return parser.parse_args()

CMDS = {
    "add": [add_key, ["update"]],
    "rm": [remove_key, ["update"]],
    "jump": [show_path, []],
    "show": [show_file, ["nokey"]],
    "help": [output_help, ["nopathmap", "nokey"]]
}
HELP_PATH = Path(os.getenv("DOTFILES")) / "src/jump/help.txt"

def main(pathmap_path, cmd, key):
    pathmap = load_file(pathmap_path)
    func = CMDS[cmd][0]
    attr = CMDS[cmd][1]
    if ("nokey" in attr) and ("nopathmap" in attr):
        func()
    elif ("nokey" in attr):
        func(pathmap)
    else:
        func(pathmap, key)
    if "update" in attr:
        save_file(pathmap_path, pathmap)
    return

if __name__ == '__main__':
    args = get_args()
    cmd, key = get_cmd_key(args.cmd_key_list)
    main(args.pathmap_path, cmd, key)

# EOF
