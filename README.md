# pkilld
A daemon to watch for long running processes and kill them based on uptime

## usage
```sh
pkilld [OPTIONS] process_name process_uptime
```
### Options
  * **uid**: Only kill processes started by user with a specific UID (default: all users)
  * **sleep**: Specify the number of seconds between daemon cycles (default: 1 second)
  
## TODO
Implement the standard daemon API: start, status, stop
