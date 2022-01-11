#!/usr/bin/env python
# coding: utf-8

def output_errmsg(msg):
    print("Error:", msg)
def output_help():
    print("Read help file [~/df/src/jump/help.txt].")

def get_sortkeys(keypath):
    keylist = list(keypath.keys())
    return sort(keylist)

def get_keypath(keypath_path):
    keypath = {}
    with open(keypath_path, 'r') as ifile:
        lnum = 0
        for line in ifile:
            lnum += 1
            if (lnum % 2) == 1: # lnum is odd.
                key = line
            else: # lnum is even, line is path.
                keypath[key] = line
    return keypath

def write_file(keypath_path, keypath):
    keys = get_sortkeys(keypath)
    with open(keypath_path, 'w') as ofile:
        for key in keys:
            ofile.write(key + "\n")
            ofile.write(keypath[key] + "\n")

def show_file(keypath):
    keys = get_sortkeys(keypath)
    maxlen = 0
    for key in keys:
        maxlen = max(maxlen, len(key))




def main():

if __name__ == '__main__':
    main()

# EOF
