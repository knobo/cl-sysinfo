# cl-sysinfo

A CFFI wrapper for the Linux [`sysinfo(2)`](https://man7.org/linux/man-pages/man2/sysinfo.2.html)
syscall, giving access to uptime, load averages, and memory/swap usage.

> **Platform:** Linux only. The binding groves `sys/sysinfo.h`, which is
> provided by glibc on Linux; it will not build on macOS or the BSDs.

## Installation

The system depends on [`cffi`](https://cffi.common-lisp.dev/) (with
`cffi-grovel`) and [`local-time-duration`](https://github.com/enaeher/local-time-duration),
and needs a C compiler available for the grovel step.

```common-lisp
(asdf:load-system "cl-sysinfo")
```

## API

### `(sysinfo:sysinfo)` → plist

Returns the current system statistics as a plist:

```common-lisp
(sysinfo:sysinfo)
;; =>
;; (:UPTIME 472031 :LOADS (1.8579102 1.9272461 1.4038086) :TOTALRAM 20764299264
;;  :FREERAM 1156550656 :SHAREDRAM 1182826496 :BUFFERRAM 699760640 :TOTALSWAP
;;  2147479552 :FREESWAP 2147479552 :PROCS 2372 :TOTALHIGH 0 :FREEHIGH 0 :MEM-UNIT
;;  1)
```

| Key          | Meaning                                                     |
|--------------|-------------------------------------------------------------|
| `:uptime`    | Seconds since boot                                          |
| `:loads`     | 1-, 5- and 15-minute load averages (single-floats)          |
| `:totalram`  | Total usable main memory                                    |
| `:freeram`   | Available memory                                            |
| `:sharedram` | Amount of shared memory                                     |
| `:bufferram` | Memory used by buffers                                      |
| `:totalswap` | Total swap space                                            |
| `:freeswap`  | Free swap space                                             |
| `:procs`     | Number of current processes                                 |
| `:totalhigh` | Total high memory                                           |
| `:freehigh`  | Available high memory                                       |
| `:mem-unit`  | Size, in bytes, of the memory unit used by the fields above |

> **Note:** All memory and swap sizes are expressed in units of `:mem-unit`
> bytes, not bytes. Multiply by `:mem-unit` to get a value in bytes (it is
> usually `1`).

### `(sysinfo:sysinfo-alist)` → alist

The same data as `sysinfo`, but as an association list of `(KEY . VALUE)`.

### `(sysinfo:sysinfo-list)` → list

Just the values, in the same order as `sysinfo`.

### `(sysinfo:uptime-duration)` → `local-time-duration:duration`

The system uptime as a `local-time-duration` duration, ready for formatting
or arithmetic.

### Conditions

`sysinfo:sysinfo-error` is signalled (a subclass of `cl:error`) if the
syscall fails. Its return code is available via `sysinfo:sysinfo-error-code`.

## Tests

```common-lisp
(asdf:test-system "cl-sysinfo")
```

The test suite uses [FiveAM](https://github.com/lispci/fiveam).

## License

LLGPL — see [LICENSE](LICENSE).
