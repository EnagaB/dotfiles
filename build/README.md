# Build in Ubuntu, Cygwin

Build my environment.
```
$ cd /path/to/df/build
$ ./buildenv.bash [--no-admin] [--no-install]
```

### Cygwin
**Create Cygwin without administrative privileges.**<br>
Download `setup-x86_64.exe` from Cygwin homepage. In powershell,
```
> setup-x86_64.exe --no-admin
```
This command is also used when install packages.

---
### Note
- When use Cygwin, not set environment variable 'HOME' in Windows.<br>
If set 'HOME' in windows, home directory in Cygwin is 'HOME', not '/home/username'.

<!-- end -->