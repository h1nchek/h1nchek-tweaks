#!/system/bin/sh
MODDIR=$(dirname "$(readlink -f "$0")")
. "$MODDIR/config.sh"

[ "$PROFILE" != "custom" ] && [ -f "$MODDIR/profiles/$PROFILE.sh" ] && . "$MODDIR/profiles/$PROFILE.sh"

prop_set() {
  [ "$(settings get global "$1" 2>/dev/null)" != "$2" ] && settings put global "$1" "$2"
}

is_managed() {
  for m in /data/adb/modules/*/; do
    [ "$m" = "$MODDIR/" ] && continue
    [ -f "${m}system.prop" ] && grep -q "$1" "${m}system.prop" 2>/dev/null && return 0
    [ -f "${m}service.sh" ] && grep -q "$1" "${m}service.sh" 2>/dev/null && return 0
  done
  return 1
}

# --- animations ---
if [ "$MANAGE_ANIM" = "1" ]; then
  CUR=$(settings get global window_animation_scale 2>/dev/null)
  if [ "$CUR" != "$ANIM_SCALE" ]; then
    prop_set window_animation_scale "$ANIM_SCALE"
    prop_set transition_animation_scale "$ANIM_SCALE"
    prop_set animator_duration_scale "$ANIM_SCALE"
  fi
fi

# --- doze ---
if [ "$MANAGE_DOZE" = "1" ]; then
  prop_set app_standby_enabled "$DOZE_ENABLED"
  if [ "$DOZE_AGGRESSIVE" = "1" ]; then
    prop_set device_idle_constants "light_after_inactive_to=30000,light_idle_to=60000,light_idle_factor=1.5,light_max_idle_to=300000"
  else
    settings delete global device_idle_constants 2>/dev/null
  fi
  prop_set adaptive_battery_management_enabled "$ADAPTIVE_BATTERY"
fi

# --- dns ---
if [ "$MANAGE_DNS" = "1" ] && ! is_managed "private_dns"; then
  prop_set private_dns_mode "$DNS_MODE"
  prop_set private_dns_specifier "$DNS_HOST"
fi

# --- network ---
if [ "$TCP_FASTOPEN" = "1" ]; then
  [ "$(cat /proc/sys/net/ipv4/tcp_fastopen 2>/dev/null)" != "3" ] && \
    sysctl -w net.ipv4.tcp_fastopen=3 2>/dev/null
fi
sysctl -w net.core.rmem_max=2097152 2>/dev/null
sysctl -w net.core.wmem_max=2097152 2>/dev/null

# wifi scan throttle
if [ "$WIFI_SCAN_THROTTLE" = "1" ]; then
  prop_set wifi_scan_throttle_enabled 1
fi

# --- cpu governor ---
if [ "$MANAGE_CPU" = "1" ] && ! is_managed "scaling_governor"; then
  for gov in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do
    [ -w "$gov" ] && echo "$CPU_GOV" > "$gov" 2>/dev/null
  done
fi

# --- swappiness ---
if [ -w /proc/sys/vm/swappiness ]; then
  [ "$(cat /proc/sys/vm/swappiness)" != "$SWAPPINESS" ] && \
    echo "$SWAPPINESS" > /proc/sys/vm/swappiness 2>/dev/null
fi

# zram writeback (если поддерживается ядром)
if [ "$ZRAM_WRITEBACK" = "1" ] && [ -w /sys/block/zram0/writeback ]; then
  echo idle > /sys/block/zram0/writeback 2>/dev/null
fi

# --- gpu renderer ---
if ! is_managed "debug.hwui.renderer"; then
  resetprop debug.hwui.renderer "$GPU_RENDERER" 2>/dev/null
fi

# --- debug props (осторожно) ---
if [ "$DEBUG_PROPS_OFF" = "1" ]; then
  resetprop ro.debuggable 0 2>/dev/null
  resetprop ro.secure 1 2>/dev/null
fi

# --- usage stats ---
prop_set usage_stats_enabled "$USAGE_STATS"

# --- thermal (своё добавление) ---
# 0=default 1=performance 2=battery-saver — только если ядро поддерживает
if [ "$THERMAL_MODE" != "0" ] && [ -f /sys/class/thermal/thermal_message/sconfig ]; then
  echo "$THERMAL_MODE" > /sys/class/thermal/thermal_message/sconfig 2>/dev/null
fi

# heap growth limit override (своё добавление — снимаем ограничение на heap для приложений)
if [ "$HEAP_GROWTH_LIMIT" = "1" ]; then
  resetprop dalvik.vm.heapgrowthlimit 256m 2>/dev/null
  resetprop dalvik.vm.heapmaxfree 8m 2>/dev/null
fi

echo "OK"
