# Roistat — документация на русском

How-to для разработчиков, которые подключают гем `roistat` к приложению на Ruby или Rails.

**Предпосылки:** Ruby 3+, ключ API Roistat, id проекта. Полные таблицы методов — в [корневом README](../../README.md) (английский).

Демо с read-only вызовами: [roistat_demo](https://github.com/alec-c4/roistat_demo).

Официальные справочники Roistat:

- [help-ru](https://help-ru.roistat.com/API/methods/about/) — основная инвентаризация путей
- [help-en](https://help.roistat.com/API/methods/about/) — дашборды, виджеты и часть путей access/counter

## Содержание

- [Установка](#установка)
- [Конфигурация](#конфигурация)
- [Клиенты](#клиенты)
- [Группы ресурсов](#группы-ресурсов)
- [Ответы и ошибки](#ответы-и-ошибки)
- [Разработка](#разработка)

## Установка

Добавьте гем в Gemfile:

```ruby
gem "roistat"
```

Затем:

```fish
bundle install
```

### Rails

```fish
bundle exec rails generate roistat:install
```

Генератор создаёт `config/initializers/roistat.rb` со всеми опциями и привязкой к ENV.

## Конфигурация

### Глобальная (удобно для Rails)

```ruby
Roistat.configure do |config|
  config.api_key = ENV.fetch("ROISTAT_API_KEY")
  config.project = ENV.fetch("ROISTAT_PROJECT_ID")
end

Roistat.client.projects.list
```

### Опции

| Опция | Обязательна | По умолчанию | Назначение |
|-------|-------------|--------------|------------|
| `api_key` | да | — | ключ в заголовке `Api-key` |
| `project` | для project-scoped вызовов | — | query `project` |
| `base_url` | нет | `https://cloud.roistat.com/api/v1` | базовый URL |
| `timeout` | нет | `30` | таймаут запроса (сек) |
| `open_timeout` | нет | `10` | таймаут открытия соединения |
| `binary_tempfile_threshold` | нет | `1048576` (1 MiB) | порог для `Tempfile` |

Каждый запрос уходит с заголовком `Api-key`. Параметр `key` в query гем не использует.

## Клиенты

### Общий клиент

`Roistat.client` собирается из глобальной конфигурации.

### Отдельный клиент

Удобно для нескольких проектов, джобов и скриптов:

```ruby
client = Roistat::Client.new(
  api_key: ENV.fetch("ROISTAT_API_KEY"),
  project: "12345"
)
client.orders.list(limit: 10)
```

### Низкоуровневый HTTP

Если для пути ещё нет resource-метода:

```ruby
client.get("project/calltracking/phone/list", params: {limit: 10})
client.post("project/events/send", body: {name: "purchase"})
```

## Группы ресурсов

Ниже — точки входа. Сигнатуры и примеры смотрите в [английском README](../../README.md#resource-apis).

| Группа | Клиент | Примеры задач |
|--------|--------|---------------|
| Projects | `client.projects` | список проектов, модули / counter list |
| Access | `client.access` | права пользователей (RU и EN пути) |
| Dashboards / Widgets | `client.dashboards`, `client.widgets` | дашборды и данные виджетов (EN) |
| Billing | `client.billing` | транзакции и Excel-экспорт |
| Calltracking | `client.calltracking` | скрипты, номера, звонки |
| Orders / proxy / leads | `client.orders`, `client.proxy_leads`, `client.leads` | сделки и лиды |
| Managers / lead hunter | `client.managers`, `client.lead_hunter` | менеджеры и охотник за лидами |
| Clients / visits / events | `client.clients`, `client.visits`, `client.events` | клиенты, визиты, события |
| Analytics / channels | `client.analytics`, `client.channels` | отчёты и источники |
| Statistics / indicators | `client.statistics`, `client.indicators` | дневная статистика и индикаторы |
| Email / SMS / mediaplan | `client.emailtracking`, `client.sms`, `client.mediaplan` | почта, SMS-отчёт, медиаплан |
| Speech / VPBX | `client.speech`, `client.vpbx` | речевая аналитика и облачная АТС |

Мутирующие методы (create / update / delete / buy / send) меняют данные в Roistat. Используйте их осознанно.

## Ответы и ошибки

- JSON-эндпоинты возвращают разобранный Hash (строковые ключи).
- Бинарные ответы: `String`, если тело ≤ 1 MiB; иначе `Tempfile` (закройте и удалите файл после использования).

| Код Roistat `error` | Исключение |
|---------------------|------------|
| `authentication_failed` | `Roistat::AuthenticationError` |
| `authorization_failed` | `Roistat::AuthorizationError` |
| `access_denied` | `Roistat::AccessDeniedError` |
| `request_limit_error` | `Roistat::RateLimitError` |
| прочее | `Roistat::Error` |

Ошибки конфигурации (пустой ключ или project) поднимают `Roistat::ConfigurationError` до HTTP.

## Разработка

```fish
bin/setup
bundle exec rake
# или: mise test ; and mise lint
```

Интерактивная консоль гема: `bin/console`.

Демо-репозиторий: [roistat_demo](https://github.com/alec-c4/roistat_demo).

Багрепорты и PR: https://github.com/alec-c4/roistat
