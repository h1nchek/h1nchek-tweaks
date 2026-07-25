SKIPUNZIP=0
ui_print "- h1nchek_tweaks v5.0"
ui_print "- Device: $(getprop ro.product.model)"
ui_print "- Android: $(getprop ro.build.version.release) (SDK $(getprop ro.build.version.sdk))"
ui_print "- ABI: $ARCH"

API=$(getprop ro.build.version.sdk)
[ "$API" -lt 26 ] && ui_print "! Android < 8.0, часть твиков может не сработать"

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/post-fs-data.sh 0 0 0755
set_perm $MODPATH/apply.sh 0 0 0755
set_perm $MODPATH/actions.sh 0 0 0755
set_perm $MODPATH/cpu_detect.sh 0 0 0755

if [ "$IS64BIT" = "true" ]; then
  rm -f "$MODPATH/system/bin/busybox_arm"
  set_perm "$MODPATH/system/bin/busybox_arm64" 0 2000 0755
  ui_print "- busybox: arm64"
else
  rm -f "$MODPATH/system/bin/busybox_arm64"
  set_perm "$MODPATH/system/bin/busybox_arm" 0 2000 0755
  ui_print "- busybox: arm"
fi

for d in /data/adb/modules /data/adb/ap/modules /data/adb/ksu/modules; do
  if [ -f "$d/h1nchek_tweaks/config.sh" ]; then
    cp -f "$d/h1nchek_tweaks/config.sh" "$MODPATH/config.sh" 2>/dev/null
    ui_print "- config.sh сохранён"
    break
  fi
done

ui_print "- Готово, нужна перезагрузка"
