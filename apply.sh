#!/system/bin/sh
MODDIR=$(dirname "$(readlink -f "$0")")
. "$MODDIR/config.sh"

[ "$PROFILE" != "custom" ] && [ -f "$MODDIR/profiles/$PROFILE.sh" ] && . "$MODDIR/profiles/$PROFILE.sh"

settings put global window_animation_scale "$ANIM_SCALE"
settings put global transition_animation_scale "$ANIM_SCALE"
settings put global animator_duration_scale "$ANIM_SCALE"
settings put global app_standby_enabled "$DOZE_ENABLED"

if [ "$DOZE_AGGRESSIVE" = "1" ]; then
  settings put global device_idle_constants "light_after_inactive_to=30000,light_idle_to=60000,light_idle_factor=1.5,light_max_idle_to=300000"
else
  settings delete global device_idle_constants 2>/dev/null
fi

settings put global adaptive_battery_management_enabled "$ADAPTIVE_BATTERY"
settings put global private_dns_mode "$DNS_MODE"
settings put global private_dns_specifier "$DNS_HOST"

[ "$TCP_FASTOPEN" = "1" ] && sysctl -w net.ipv4.tcp_fastopen=3 2>/dev/null
sysctl -w net.core.rmem_max=2097152 2>/dev/null
sysctl -w net.core.wmem_max=2097152 2>/dev/null

if [ "$DEBUG_PROPS_OFF" = "1" ]; then
  resetprop ro.debuggable 0
  resetprop ro.secure 1
fi

settings put global usage_stats_enabled "$USAGE_STATS"

for gov in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do
  [ -w "$gov" ] && echo "$CPU_GOV" > "$gov" 2>/dev/null
done

[ -w /proc/sys/vm/swappiness ] && echo "$SWAPPINESS" > /proc/sys/vm/swappiness 2>/dev/null
resetprop debug.hwui.renderer "$GPU_RENDERER"
echo "OK"
