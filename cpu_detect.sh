#!/system/bin/sh
COUNT=0
for c in /sys/devices/system/cpu/cpu[0-9]*; do [ -d "$c" ] && COUNT=$((COUNT+1)); done
CLUSTERS=$(for c in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/related_cpus; do [ -r "$c" ] && cat "$c"; done | sort -u | grep -c .)
echo "cpus=$COUNT clusters=$CLUSTERS"
