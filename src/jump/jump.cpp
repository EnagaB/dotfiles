// Compile command:
//   > g++ -std=c++17 -Wall <this> -o <output_path>

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <map>
#include <string>
#include <set>
#include <algorithm>
#include <filesystem>
#include <stdexcept>

using namespace std;
using namespace std::filesystem;
using cmdfunc = void (*)(map<string, path> &pathmap, string key);
using cmdfunc_nokey = void (*)(map<string, path> &pathmap);

// command function prototypes
void add_key(map<string, path> &pathmap, string key);
void remove_key(map<string, path> &pathmap, string key);
void show_path(map<string, path> &pathmap, string key);
void show_file(map<string, path> &pathmap);
void output_help();

// parameters
map<string, pair<cmdfunc, set<string>>> CMDS = {
  {"add", make_pair(add_key, set<string>{"update"})},
  {"rm", make_pair(remove_key, set<string>{"update"})},
  {"jump", make_pair(show_path, set<string>{})}
};
map<string, pair<cmdfunc_nokey, set<string>>> PATHMAP_CMDS = {
  {"show", make_pair(show_file, set<string>{})}
};
map<string, pair<void (*)(), set<string>>> OTHER_CMDS = {
  {"help", make_pair(output_help, set<string>{})}
};
const char *DOTFILES = getenv("DOTFILES");
static path HELP_PATH = path(DOTFILES) / "share" / "help" / "jump.txt";

// command functions
void add_key(map<string, path> &pathmap, string key) {
  if (pathmap.count(key)) {
    string msg("Input key exists in pathmap file.");
    throw runtime_error(msg);
  }
  pathmap.emplace(key, current_path());
  cout << "Add input key and current path to pathmap file." << endl;
}

void remove_key(map<string, path> &pathmap, string key) {
  if (! pathmap.count(key)) {
    string msg("Input key does not exist in pathmap file.");
    throw runtime_error(msg);
  }
  pathmap.erase(key);
  cout << "Remove input key and its path in file." << endl;
}

void show_path(map<string, path> &pathmap, string key) {
  if (! pathmap.count(key)) {
    string msg("Input key does not exist in pathmap file.");
    throw runtime_error(msg);
  }
  if (! is_directory(pathmap[key])) {
    string msg("Path of input key does not exist.");
    throw runtime_error(msg);
  }
  cout << pathmap[key].string() << endl;
}

void show_file(map<string, path> &pathmap) {
  int maxlen_keys=0;
  for (const auto& [kk, pp]: pathmap) {
    maxlen_keys=max(maxlen_keys, (int)kk.length());
  }
  for (const auto& [kk, pp]: pathmap) {
    cout << setw(maxlen_keys) << left << kk << ": " << pp.string() << endl;
  }
}

void output_help() {
  ifstream help_file(HELP_PATH);
  if (! help_file) {
    string msg("Cannot open help file.");
    msg += " Help filepath: " + HELP_PATH.string();
    throw runtime_error(msg);
  }
  string help_line;
  while (getline(help_file, help_line)) {
    cout << help_line << endl;
  }
}

// is exist
bool is_cmd_exist(string cmd) {
  if (CMDS.find(cmd) != CMDS.end() || 
      PATHMAP_CMDS.find(cmd) != PATHMAP_CMDS.end() ||
      OTHER_CMDS.find(cmd) != OTHER_CMDS.end()) {
    return true;
  }
  return false;
}

bool is_cmd_exist_nokey(string cmd) {
  if (PATHMAP_CMDS.find(cmd) != PATHMAP_CMDS.end() ||
      OTHER_CMDS.find(cmd) != OTHER_CMDS.end()) {
    return true;
  }
  return false;
}

// save and load file
map<string, path> load_pathmap_file(path pathmap_filepath) {
  map<string, path> pathmap;
  // if pathmap_file does not exist, create.
  if (! exists(pathmap_filepath)) {
    ofstream tmp(pathmap_filepath);
    tmp.close();
    return pathmap;
  }
  ifstream pathmap_file(pathmap_filepath);
  if (! pathmap_file) {
    string msg;
    msg = "Cannot open file for loading pathmap.";
    msg += " File path: " + pathmap_filepath.string();
    throw runtime_error(msg);
  }
  string wkey;
  path wpath;
  bool even = false;
  string fileline;
  while (getline(pathmap_file, fileline)) {
    if (! even) { wkey = fileline; }
    else {
      wpath = fileline;
      pathmap.emplace(wkey, wpath);
    }
    even = ! even;
  }
  return pathmap;
}

void save_pathmap_file(path pathmap_filepath, map<string, path> &pathmap) {
  ofstream pathmap_file(pathmap_filepath);
  if (! pathmap_file) {
    string msg;
    msg = "Cannot open file for saving pathmap.";
    msg += " File path: " + pathmap_filepath.string();
    throw runtime_error(msg);
  }
  for (const auto& [kk, pp]: pathmap) {
    pathmap_file << kk << endl;
    pathmap_file << pp.string() << endl;
  }
}

// get arguments
tuple<path, string, string> get_args(int argc, char* argv[]) {
  if (argc == 1 || argc > 4) {
    throw invalid_argument("Num of arguments is wrong. See help.");
  }
  path pathmap_filepath(argv[1]);
  string cmd, key;
  if (argc == 2) {
    cmd = "show";
  }
  else if (argc == 3 && is_cmd_exist_nokey(argv[2])) {
    cmd = argv[2];
  }
  else if (argc == 3) {
    cmd = "jump";
    key = argv[2];
  }
  else { // argc = 4
    cmd = argv[2];
    key = argv[3];
  }
  if (! is_cmd_exist(cmd)) {
    string msg;
    msg = "Given command '" + cmd + "' does not implemented.";
    throw invalid_argument(msg);
  }
  if (is_cmd_exist_nokey(key)) {
    string msg;
    msg = "Given key '" + key + "' cannot be used.";
    msg += " The key is same name as one of nokey_commands";
    throw invalid_argument(msg);
  }
  return {pathmap_filepath, cmd, key};
}

int main(int argc, char* argv[]) {
  auto [pathmap_filepath, cmd, key] = get_args(argc, argv);
  map<string, path> pathmap = load_pathmap_file(pathmap_filepath);
  set<string> attr;
  if (CMDS.find(cmd) != CMDS.end()) {
    (*CMDS[cmd].first)(pathmap, key);
    attr = CMDS[cmd].second;
  }
  else if (PATHMAP_CMDS.find(cmd) != PATHMAP_CMDS.end()) {
    (*PATHMAP_CMDS[cmd].first)(pathmap);
    attr = PATHMAP_CMDS[cmd].second;
  }
  else if (OTHER_CMDS.find(cmd) != OTHER_CMDS.end()) {
    (*OTHER_CMDS[cmd].first)();
    attr = OTHER_CMDS[cmd].second;
  }
  if (attr.find("update") != attr.end()) { save_pathmap_file(pathmap_filepath, pathmap); }
  return 0;
}

// EOF
