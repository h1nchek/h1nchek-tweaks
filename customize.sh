SKIPUNZIP=0
ui_print "- h1nchek_tweaks v1.0"
ui_print "- Device: $(getprop ro.product.model)"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/post-fs-data.sh 0 0 0755
ui_print "- Готово, нужна перезагрузка"
