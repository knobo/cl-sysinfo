# sysinfo

This is a project is a cffi wrapper for the sysinfo(2) syscall

## License

LLGPL


## API

```common-lisp
;; Return sysinfo as a plist:
(sysinfo:sysinfo)

(:UPTIME 472031 :LOADS (1.8579102 1.9272461 1.4038086) :TOTALRAM 20764299264
 :FREERAM 1156550656 :SHAREDRAM 1182826496 :BUFFERRAM 699760640 :TOTALSWAP
 2147479552 :FREESWAP 2147479552 :PROCS 2372 :TOTALHIGH 0 :FREEHIGH 0 :MEM-UNIT
 1)
```
