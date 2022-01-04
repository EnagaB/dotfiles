// Compile command:
//   > g++ -std=c++17 <this> -o <output_path>

#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <string>
#include <map>
#include <filesystem>

using namespace std;
using namespace std::filesystem;

// parameter
const string ADD_CMD = "add";
const string REMOVE_CMD = "rm";
const string REPLACE_CMD = "rep";
const string JUMP_CMD = "jump";
const string SHOW_CMD = "show";
const string HELP_CMD = "help";

// help file path
const char *DOTFILES = getenv("DOTFILES");
static path HELP_PATH = path(DOTFILES).append("src/jump/help.txt");

// outputs
void output_errmsg(string msg) { cerr << "Error: " << msg; }

bool output_help() {
  ifstream help_file(HELP_PATH);
  if (! help_file) {
    output_errmsg("Cannot open help file.");
    cerr << "Help file path: " << HELP_PATH.string() << endl;
    return false;
  }
  string help_line;
  while (getline(help_file, help_line)) {
    cout << help_line << endl;
  }
  return true;
}

// load keypath file
map<string, path> get_keypath(path keypath_path) {
  map<string, path> keypath;
  // if file does not exist, create.
  if (! exists(keypath_path)) {
    ofstream tmp(keypath_path);
    tmp.close();
    return keypath;
  }
  ifstream keypath_file(keypath_path);
  if (! keypath_file) {
    output_errmsg("Cannot open keypath file.");
    cerr << "Keypath file path: " << keypath_path.string() << endl;
    exit(1);
  }
  string wkey, line;
  path wpath;
  bool even = false;
  while (getline(keypath_file, line)) {
    if (! even) {
      even = true;
      wkey = line;
    }
    else {
      even = false;
      wpath = line;
      keypath.emplace(wkey, wpath);
    }
  }
  return keypath;
}

// write keypath file
void write_file(path keypath_path, map<string, path> &keypath) {
  ofstream keypath_file(keypath_path);
  if (! keypath_file) {
    output_errmsg("Cannot open keypath file.");
  }
  for (const auto& [kk, pp]: keypath) {
    keypath_file << kk << endl;
    keypath_file << pp.string() << endl;
  }
}

// jump commands
void show_file(map<string, path> &keypath) {
  int maxlen_keys=0;
  for (const auto& [kk, pp]: keypath) {
    maxlen_keys=max(maxlen_keys, (int)kk.length());
  }
  for (const auto& [kk, pp]: keypath) {
    cout << setw(maxlen_keys) << left << kk << ": " << pp.string() << endl;
  }
}

bool show_path(map<string, path> &keypath, string key) {
  if (! keypath.count(key)) {
    output_errmsg("Input key does not exist in file.");
    return false;
  }
  if (! is_directory(keypath[key])) {
    output_errmsg("Path of input key does not exist.");
    return false;
  }
  cout << keypath[key].string() << endl;
  return true;
}

bool add_key(map<string, path> &keypath, string key) {
  if (keypath.count(key)) {
    output_errmsg("Input key exists in file.");
    return false;
  }
  keypath.emplace(key, current_path());
  cout << "Add input key to file." << endl;
  return true;
}

bool remove_key(map<string, path> &keypath, string key) {
  if (! keypath.count(key)) {
    output_errmsg("Input key does not exist in file.");
    return false;
  }
  keypath.erase(key);
  cout << "Remove input key in file." << endl;
  return true;
}

bool replace_key(map<string, path> &keypath, string key) {
  return remove_key(keypath, key) && add_key(keypath, key);
}

int main(int argc, char* argv[]) {
  // get arguments
  if (argc == 1 || argc > 4) {
    output_errmsg("Num of arguments is wrong.");
    output_help();
    return 1;
  }
  path keypath_path = argv[1];
  string cmd;
  string key;
  vector<string> cmd_list = {ADD_CMD, REMOVE_CMD, REPLACE_CMD, JUMP_CMD, SHOW_CMD, HELP_CMD};
  if (argc == 2) {
    cmd = "show";
  }
  else if (argc == 3) {
    cmd = argv[2];
    if (find(cmd_list.begin(), cmd_list.end(), cmd) == cmd_list.end()) {
      cmd = "jump";
      key = argv[2];
    }
  }
  else { // argc = 4
    cmd = argv[2];
    key = argv[3];
  }
  // read file
  map<string, path> keypath;
  keypath = get_keypath(keypath_path);
  // exe
  bool update_file = false;
  bool success = false;
  if (cmd == ADD_CMD) {
    success = add_key(keypath, key);
    update_file = true;
  }
  else if (cmd == REMOVE_CMD) {
    success = remove_key(keypath, key);
    update_file = true;
  }
  else if (cmd == REPLACE_CMD) {
    success = replace_key(keypath, key);
    update_file = true;
  }
  else if (cmd == JUMP_CMD) {
    success = show_path(keypath, key);
  }
  else if (cmd == SHOW_CMD) {
    show_file(keypath);
    success = true;
  }
  else if (cmd == HELP_CMD) {
    success = output_help();
  }
  // write file
  if (update_file) { write_file(keypath_path, keypath); }
  // return
  if (! success) { return 1; }
  return 0;
}

// EOF
