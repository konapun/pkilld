# pkilld
A daemon to watch for long running processes and kill them based on uptime

## usage
```sh
pkilld [OPTIONS] process_name process_uptime
```
### Options
  * **uid**: Only kill processes started by user with a specific UID (default: all users)
  * **sleep**: Specify the number of seconds between daemon cycles (default: 1 second)

## Requirements
You may or may not already have the following list of dependencies (all available via CPAN. Someday I might automate this...)
  * Proc::ProcessTable
  * Daemon::Daemonize
  * Getopt::Long

## TODO
Implement the standard daemon API: start, status, stop
