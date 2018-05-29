# sysinfo
### _Knut Olav Bøhmer <bohmer@gmail.com>_

This is a project is a cffi wrapper for the sysinfo systemcall

## License

LLGPL


## API

```common-lisp
;; Return sysinfo as a list:
(sysinfo:sysinfo-list)
;; (468627 (1.03125 1.0483398 0.9091797) 20764299264 2816815104 1152978944 486129664 2147479552 2147479552 2319 0 0 1)

;; Return sysinfo as alist:
(sysinfo:sysinfo-alist)
;; (:UPTIME 468643 :LOADS (0.8823242 1.0126953 0.89990234) :TOTALRAM 20764299264
;;  :FREERAM 2816053248 :SHAREDRAM 1153130496 :BUFFERRAM 486174720 :TOTALSWAP
;; 2147479552 :FREESWAP 2147479552 :PROCS 2320 :TOTALHIGH 0 :FREEHIGH 0 :MEM-UNIT
;; 1)

;; Return sysinfo as struct
(sysinfo:sysinfo)
;; #<SYSINFO:SYSINFO {10030B9393}>

```
