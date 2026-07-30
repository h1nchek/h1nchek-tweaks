# h1nchek_tweaks

Magisk-модуль с твиками производительности, сети и приватности.

## Требования
- Android 8.0+ (API 26+)
- Magisk / KernelSU / APatch

## Совместимость WebUI
Открывается через менеджер с поддержкой WebUI: KernelSU Manager, APatch, MMRL.
Официальный Magisk App WebUI не поддерживает.

## Changelog

### v1.0
Базовая версия: статичные пропы + service.sh с фиксированными значениями.

### v2.0
Настройки вынесены в config.sh. Добавлен apply.sh (применение без ребута).
Первый WebUI: минимальный тёмный, базовая форма с настройками.

### v3.0
Добавлены: cpu governor, swappiness, gpu renderer, aggressive doze, профили (gaming/battery/balanced).
WebUI: тёмная тема, карточки, toggles, лог операций, кнопка сброса к дефолтам.

### v4.0
Улучшен вывод установки (customize.sh): ABI, проверка API, сохранение config.sh при обновлении.
WebUI: добавлен выбор профиля.

### v5.0
Добавлены: busybox (arm/arm64, лишний удаляется при установке), actions.sh (kill mediaserver, clear RAM).
Совместимость с APatch (поиск модуля по нескольким путям в WebUI и customize.sh).
WebUI: нейтральный тёмный/светлый по prefers-color-scheme, system font, iOS-style toggles, кнопки действий.

### v6.0
Исправлена совместимость с Android 14/15 (бутлуп на некоторых прошивках):
- убран system.prop с безусловными ro.secure/ro.debuggable/ro.build.type — раньше применялись на каждой загрузке в обход настроек
- убрано принудительное отключение USB (persist.sys.usb.config=none) из post-fs-data.sh — блокировало ADB-восстановление
- DEBUG_PROPS_OFF по умолчанию выключен
- добавлена защита от бутлупа: post-fs-data.sh ставит метку .boot_pending, service.sh снимает её после успешной загрузки. Если система не догрузилась (метка осталась) — модуль создаёт файл disable и сам отключается на следующем старте, без ручного вмешательства через recovery

### v7.0
Inter-module compatibility: checks if another module already manages CPU governor, DNS, or animations before applying; skips if managed elsewhere (configurable via MANAGE_CPU/MANAGE_DNS/MANAGE_ANIM/MANAGE_DOZE flags).
New tweaks: ZRAM writeback, heap growth limit override, WiFi scan throttle, thermal mode.
WebUI: EN/RU language toggle (persisted in localStorage), full settings exposure including per-feature manage flags.
All output in English.
