#!/system/bin/sh
MODDIR=$(dirname "$(readlink -f "$0")")
BB="$MODDIR/system/bin/busybox_arm64"
[ -x "$BB" ] || BB="$MODDIR/system/bin/busybox_arm"
[ -x "$BB" ] || BB=$(which busybox 2>/dev/null)
[ -x "$BB" ] || BB=$(which toybox 2>/dev/null)

case "$1" in
  killmediaserver)
    killall mediaserver 2>/dev/null
    killall media.codec 2>/dev/null
    echo "done"
    ;;
  clearram)
    BEFORE=$("$BB" free -m 2>/dev/null | "$BB" awk '/Mem:/{print $3}' 2>/dev/null)
    for pkg in $(pm list packages -3 | sed 's/package://'); do
      am kill "$pkg" 2>/dev/null
    done
    sync
    [ -w /proc/sys/vm/drop_caches ] && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    AFTER=$("$BB" free -m 2>/dev/null | "$BB" awk '/Mem:/{print $3}' 2>/dev/null)
    echo "before=${BEFORE}MB after=${AFTER}MB"
    ;;
  cpuinfo)
    sh "$MODDIR/cpu_detect.sh"
    ;;
  *)
    echo "unknown: $1"; exit 1
    ;;
esac
