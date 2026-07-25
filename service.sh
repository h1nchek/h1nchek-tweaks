#!/system/bin/sh
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 1; done
sh "$(dirname "$(readlink -f "$0")")/apply.sh"
