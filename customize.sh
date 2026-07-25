SKIPUNZIP=0
ui_print "- h1nchek_tweaks v4.0"
ui_print "- Device: $(getprop ro.product.model)"
ui_print "- Android: $(getprop ro.build.version.release) (SDK $(getprop ro.build.version.sdk))"
ui_print "- ABI: $ARCH"

API=$(getprop ro.build.version.sdk)
[ "$API" -lt 26 ] && ui_print "! Android < 8.0, часть твиков может не сработать"

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/post-fs-data.sh 0 0 0755
set_perm $MODPATH/apply.sh 0 0 0755

[ -f "/data/adb/modules/h1nchek_tweaks/config.sh" ] \
  && cp -f "/data/adb/modules/h1nchek_tweaks/config.sh" "$MODPATH/config.sh" 2>/dev/null \
  && ui_print "- config.sh сохранён из предыдущей версии"

ui_print "- Готово, нужна перезагрузка"
