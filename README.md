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
