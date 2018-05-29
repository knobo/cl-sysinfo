
(in-package #:sysinfo)

(include "sys/sysinfo.h")

(constant (si-load-shift "SI_LOAD_SHIFT") :type integer)

(cstruct sysinfo "struct sysinfo"
         (uptime "uptime" :type :long)
         (loads "loads" :type :long :count 3)
         (totalram "totalram" :type  :ulong)
         (freeram "freeram" :type  :ulong)
         (sharedram "sharedram" :type  :ulong)
         (bufferram "bufferram" :type  :ulong)
         (totalswap "totalswap" :type  :ulong)
         (freeswap "freeswap" :type  :ulong)
         (procs "procs" :type  :ushort)
         (totalhigh "totalhigh" :type  :ulong)
         (freehigh "freehigh" :type  :ulong)
         (mem-unit "mem_unit" :type  :int))
