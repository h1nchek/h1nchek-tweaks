#!/system/bin/sh
MODDIR=$(dirname "$(readlink -f "$0")")
. "$MODDIR/config.sh"

settings put global window_animation_scale "$ANIM_SCALE"
settings put global transition_animation_scale "$ANIM_SCALE"
settings put global animator_duration_scale "$ANIM_SCALE"
settings put global app_standby_enabled "$DOZE_ENABLED"
settings put global adaptive_battery_management_enabled "$ADAPTIVE_BATTERY"
settings put global private_dns_mode "$DNS_MODE"
settings put global private_dns_specifier "$DNS_HOST"
[ "$TCP_FASTOPEN" = "1" ] && sysctl -w net.ipv4.tcp_fastopen=3 2>/dev/null
sysctl -w net.core.rmem_max=2097152 2>/dev/null
sysctl -w net.core.wmem_max=2097152 2>/dev/null
[ "$DEBUG_PROPS_OFF" = "1" ] && resetprop ro.debuggable 0 && resetprop ro.secure 1
settings put global usage_stats_enabled "$USAGE_STATS"
echo "OK"
