#!/system/bin/sh
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 1; done
MODDIR=$(dirname "$(readlink -f "$0")")
settings put global window_animation_scale 0.5
settings put global transition_animation_scale 0.5
settings put global animator_duration_scale 0.5
settings put global app_standby_enabled 1
settings put global adaptive_battery_management_enabled 1
settings put global private_dns_mode hostname
settings put global private_dns_specifier one.one.one.one
sysctl -w net.ipv4.tcp_fastopen=3 2>/dev/null
sysctl -w net.core.rmem_max=2097152 2>/dev/null
sysctl -w net.core.wmem_max=2097152 2>/dev/null
settings put global usage_stats_enabled 0
