#!/system/bin/sh
MODDIR=$(dirname "$(readlink -f "$0")")

if [ -f "$MODDIR/.boot_pending" ]; then
  touch "$MODDIR/disable"
  rm -f "$MODDIR/.boot_pending"
  exit 0
fi

touch "$MODDIR/.boot_pending"
resetprop ro.config.hw_quickpoweron true 2>/dev/null
