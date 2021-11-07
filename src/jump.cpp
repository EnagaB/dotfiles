// 1. save key and path to save_file
// 2. output path corresponding to input key.
// [compile command]
//   > g++ -std=c++17 <this> -o ~/df/bin/__jump
// recommend in bashrc/zshrc
// declare -r __jump_file=${HOME}/.jump
// function __jumpfunc() {
//   local tmp=$(__jump "$__jump_file" "${1:-}" "${2:-}")
//   [[ -d "$tmp" ]] && cd "$tmp" || echo "$tmp"
// }
// alias jj="__jumpfunc"

#include <iostream>
#include <iomanip>
#include <fstream>
#include <cstdio>
#include <string>
#include <map>
#include <numeric>
#include <filesystem>
using namespace std;
namespace fs=std::filesystem;
using jmap=map<string,string>;

const static string DEFAULT_COMMAND="show_file";
const static string DEFAULT_KEY="def";

static string ifile;
static string icmd;
static string ikey;
jmap keypaths;

void cout_usage() {
  cout << "[usage]\n";
  cout << "> <exe file> <save_file> <command> <key>\n";
  cout << "[arguments]\n";
  cout << "arg1 = save_file: path to file containing the keys and paths\n";
  cout << "arg2 = command  : command = show_file/add/rm/replace/key\n";
  cout << "arg3 = key      : if arg2=add/rm/replace, arg3 is required.\n";
  cout << "                : else, arg3 is ignored.\n";
  cout << "num of arguments = 3 (if including <this>, num of that = 4)\n";
  cout << "Even if key is not used, require key as argument.\n";
  cout << flush;
}

// file
void read_file() {
  // file exist check, if not exist, create file.
  if (! fs::exists((fs::path)ifile)) {
    ofstream tmp(ifile);
    tmp.close();
    return;
  }
  // read file
  ifstream istm(ifile);
  if (! istm) cout << "err: cannot open " << ifile << endl, exit(1);
  string wstr;
  while (getline(istm, wstr)) {
    if (wstr.length()>2) for (int i=0; i<wstr.length(); ++i) if (wstr[i]==' ') {
      try {
        string ws1=wstr.substr(0,i);
        string ws2=wstr.substr(i+1);
        keypaths.emplace(ws1,ws2);
        break;
      }
      catch(...) {}
    }
  }
  istm.close();
}
void write_file() {
  ofstream ostm(ifile);
  if (!ostm) { cout << "err: cannot open " << ifile << endl; exit(1); }
  for (const auto& [kk,pp]: keypaths) ostm << kk << ' ' << pp << endl;
  ostm.close();
}

// jump commands
void show_file() {
  int maxlen_keys=0;
  for (const auto& [kk,pp]: keypaths) maxlen_keys=max(maxlen_keys, (int)kk.length());
  for (const auto& [kk,pp]: keypaths) {
    cout << setw(maxlen_keys) << left << kk << ": " << pp << endl;
  }
}
bool show_path() {
  if (keypaths.count(ikey)) {
    if (! is_directory((fs::path)keypaths[ikey])) {
      cout << "err: input key path diretory does not exist." << endl;
      cout << ikey << ": ";
    }
    cout << keypaths[ikey] << endl;
    return true;
  }
  else {
    cout << "err: input key [" << ikey << "] does not exist in save_file." << endl;
    return false;
  }
}

bool rm_key() {
  if (keypaths.count(ikey)) {
    keypaths.erase(ikey);
    cout << "rm input key " << ikey << " in " << ifile << endl;
    return true;
  }
  else {
    cout << "err: input key " << ikey << " don't exist in " << ifile << endl;
    return false;
  }
}
bool add_key() {
  if (! keypaths.count(ikey)) {
    keypaths.emplace(ikey, (string)fs::current_path());
    cout << "add input key " << ikey << " to " << ifile << endl;
    return true;
  }
  else {
    cout << "err: input key " << ikey << " exists in " << ifile << endl;
    return false;
  }
}
bool replace_key() { return rm_key() && add_key(); }

int main(int argc, char* argv[]) {
  // get args
  if (argc!=4) {
    cout << "err: num of args" << endl;
    cout_usage();
    exit(1);
  }
  ifile=argv[1];
  icmd=argv[2]; if (icmd.length()==0) icmd=DEFAULT_COMMAND;
  ikey=argv[3]; if (ikey.length()==0) ikey=DEFAULT_KEY;

  // read file
  jmap keypaths;
  read_file();

  // exe
  if (icmd=="show_file") show_file();
  else if (icmd=="add") {
    if (add_key()) write_file();
  }
  else if (icmd=="rm") {
    if (rm_key()) write_file();
  }
  else if (icmd=="replace" && replace_key()) write_file();
  else {
    // icmd = arg[2] = key;
    ikey=icmd;
    if (show_path()) return 0;
  }
  return 1;
}

// EOF
