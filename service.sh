#!/system/bin/sh
MODDIR=$(dirname "$(readlink -f "$0")")

until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 1; done

sh "$MODDIR/apply.sh"

rm -f "$MODDIR/.boot_pending"
