# Roistat

Ruby wrapper for the [Roistat REST API](https://help-ru.roistat.com/API/methods/about/).

**[Документация на русском](docs/ru/README.md)**

The gem sends every request with the `Api-key` header (never as a `key` query param). Project-scoped calls also send `project` in the query string.

Official docs differ by language. Prefer [help-ru](https://help-ru.roistat.com/API/methods/about/) for the method list. [help-en](https://help.roistat.com/API/methods/about/) documents additional endpoints (dashboards, widgets, and alternate access/counter paths); this gem wraps those as well.

## Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Clients](#clients)
- [Low-level HTTP API](#low-level-http-api)
- [Resource APIs](#resource-apis)
  - [Projects](#projects--clientprojects)
  - [Access](#access--clientaccess)
  - [Dashboards](#dashboards--clientdashboards)
  - [Widgets](#widgets--clientwidgets)
  - [Billing](#billing--clientbilling)
  - [Calltracking](#calltracking--clientcalltracking)
  - [Orders](#orders--clientorders)
  - [Proxy leads](#proxy-leads--clientproxy_leads)
  - [Leads](#leads--clientleads)
  - [Managers](#managers--clientmanagers)
  - [Clients](#clients--clientclients)
  - [Visits](#visits--clientvisits)
  - [Events](#events--clientevents)
  - [Analytics](#analytics--clientanalytics)
  - [Channels](#channels--clientchannels)
  - [Statistics](#statistics--clientstatistics)
  - [Indicators](#indicators--clientindicators)
  - [Lead hunter](#lead-hunter--clientlead_hunter)
  - [Email tracking](#email-tracking--clientemailtracking)
  - [SMS](#sms--clientsms)
  - [Mediaplan](#mediaplan--clientmediaplan)
  - [Speech analytics](#speech-analytics--clientspeech)
  - [Cloud PBX (VPBX)](#cloud-pbx-vpbx--clientvpbx)
- [Responses](#responses)
- [Errors](#errors)
- [Development](#development)
- [License](#license)

## Installation

Add the gem to the Gemfile:

```ruby
gem "roistat"
```

Then run:

```bash
bundle install
```

Or install it directly:

```bash
gem install roistat
```

### Rails

Generate the initializer:

```bash
rails generate roistat:install
```

This creates `config/initializers/roistat.rb` with all configuration options.

## Configuration

### Global config (Rails-friendly)

```ruby
Roistat.configure do |config|
  config.api_key = ENV.fetch("ROISTAT_API_KEY")
  config.project = ENV.fetch("ROISTAT_PROJECT_ID")

  # Optional:
  # config.base_url = "https://cloud.roistat.com/api/v1"
  # config.timeout = 30
  # config.open_timeout = 10
  # config.binary_tempfile_threshold = 1_048_576
end
```

Then use the shared client:

```ruby
Roistat.client.projects.list
```

### Configuration options

| Option | Required | Default | Description |
|--------|----------|---------|-------------|
| `api_key` | yes | — | Roistat API key (`Api-key` header) |
| `project` | yes for project-scoped calls | — | Project id (query `project`) |
| `base_url` | no | `https://cloud.roistat.com/api/v1` | API base URL |
| `timeout` | no | `30` | Request timeout in seconds |
| `open_timeout` | no | `10` | Connection open timeout in seconds |
| `binary_tempfile_threshold` | no | `1048576` (1 MiB) | Binary bodies larger than this become a `Tempfile` |

### Environment variables (install generator)

| Variable | Maps to |
|----------|---------|
| `ROISTAT_API_KEY` | `config.api_key` |
| `ROISTAT_PROJECT_ID` | `config.project` |
| `ROISTAT_BASE_URL` | `config.base_url` (commented in template) |
| `ROISTAT_TIMEOUT` | `config.timeout` (commented) |
| `ROISTAT_OPEN_TIMEOUT` | `config.open_timeout` (commented) |
| `ROISTAT_BINARY_TEMPFILE_THRESHOLD` | `config.binary_tempfile_threshold` (commented) |

## Clients

### Shared client

`Roistat.client` builds a client from the global configuration.

### Explicit client

Use a dedicated instance when you need another project or key:

```ruby
client = Roistat::Client.new(
  api_key: "…",
  project: "12345",
  timeout: 20
)

client.access.user_list
```

### API-key-only client

Some account endpoints do not need a project id:

```ruby
client = Roistat::Client.new(api_key: "…", project_required: false)
client.get("user/projects")
```

Resource helpers that are API-key-only (`projects.list`, `projects.create`) create that client internally.

Blank or whitespace-only credentials raise `Roistat::ConfigurationError` before any HTTP call.

## Low-level HTTP API

Use these for any documented Roistat path that does not have a resource method yet:

```ruby
client.get("project/calltracking/phone/list", params: {limit: 10})
client.post("project/events/send", body: {name: "purchase"})
client.request(:get, "project/permissions/user/list")
```

### Method signatures

| Method | Purpose |
|--------|---------|
| `get(path, params: {}, parse: :json)` | GET request |
| `post(path, params: {}, body: nil, parse: :json)` | POST request |
| `request(method, path, params: {}, body: nil, parse: :json)` | Arbitrary verb |

Notes:

- `path` is relative to `base_url` (leading slash is optional).
- `params` become query parameters. The client adds `project` automatically when the client has a project id.
- `body` is JSON-encoded. The gem sets `Content-Type: application/json`.
- `parse: :json` (default) returns a parsed Hash/Array.
- `parse: :binary` returns a `String` or `Tempfile` (see [Responses](#responses)).

## Resource APIs

High-level helpers are available on every client:

```ruby
client.projects
client.access
client.dashboards
client.widgets
client.billing
client.calltracking
client.orders
client.proxy_leads
client.leads
client.managers
client.clients
client.visits
client.events
client.analytics
client.channels
client.statistics
client.indicators
client.lead_hunter
client.emailtracking
client.sms
client.mediaplan
client.speech
client.vpbx
```

Official parameter details live in the [Roistat API docs](https://help-ru.roistat.com/API/methods/about/).

### Projects — `client.projects`

| Ruby method | HTTP | Path | Auth |
|-------------|------|------|------|
| `list` | GET | `/user/projects` | API key only |
| `create(name:, currency:)` | POST | `/account/project/create` | API key only |
| `modules_list(method: :get)` | GET or POST | `/project/settings/module/list` | API key + project |
| `counter_list` | POST | `/project/settings/counter/list` | API key + project (help-en) |

Examples:

```ruby
Roistat.client.projects.list
Roistat.client.projects.create(name: "Demo", currency: "RUB")
Roistat.client.projects.modules_list
Roistat.client.projects.modules_list(method: :post)
Roistat.client.projects.counter_list
```

### Access — `client.access`

| Ruby method | HTTP | Path | Auth |
|-------------|------|------|------|
| `user_list` | GET | `/project/permissions/user/list` | API key + project (help-ru) |
| `authorized_users(method: :get)` | GET or POST | `/project/access/get-authorized-users` | API key + project (help-en) |
| `change(**body)` | POST | `/project/access/change` | API key + project (help-en) |

Examples:

```ruby
Roistat.client.access.user_list
Roistat.client.access.authorized_users
Roistat.client.access.authorized_users(method: :post)
Roistat.client.access.change(email: "user@example.com", permissions: ["access_analytics_base_read"])
```

### Dashboards — `client.dashboards`

Documented on [help-en](https://help.roistat.com/API/methods/about/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list` | GET | `/project/dashboards` |
| `widgets(dashboard_id:)` | GET | `/project/dashboards/{dashboardId}/widgets` |

Examples:

```ruby
Roistat.client.dashboards.list
Roistat.client.dashboards.widgets(dashboard_id: 1)
```

### Widgets — `client.widgets`

Documented on [help-en](https://help.roistat.com/API/methods/about/). Default verb is POST (matches curl examples); pass `method: :get` when needed.

| Ruby method | HTTP | Path |
|-------------|------|------|
| `data(widget_id:, method: :post, **body)` | GET or POST | `/project/widget/{widgetId}/data` |

Examples:

```ruby
Roistat.client.widgets.data(widget_id: 9, period: "2026-01-01-2026-01-31")
Roistat.client.widgets.data(widget_id: 9, method: :get)
```

### Billing — `client.billing`

| Ruby method | HTTP | Path | Auth | Response |
|-------------|------|------|------|----------|
| `transactions_list(period:)` | POST | `/user/billing/transactions/list` | API key + project | JSON |
| `transactions_export_excel(period:)` | POST | `/user/billing/transactions/list/export/excel` | API key + project | binary |

`period` must include `from` and `to` (Roistat date strings).

Examples:

```ruby
period = {
  from: "2026-01-01T00:00:00+0300",
  to: "2026-07-22T23:59:59+0300"
}

Roistat.client.billing.transactions_list(period: period)

file = Roistat.client.billing.transactions_export_excel(period: period)
# String if ≤ 1 MiB, otherwise Tempfile
```

### Calltracking — `client.calltracking`

Official docs: [calltracking API](https://help-ru.roistat.com/API/methods/calltracking/). The gem uses POST for these endpoints.

| Ruby method | HTTP | Path | Notes |
|-------------|------|------|-------|
| `script_list(**body)` | POST | `/project/calltracking/script/list` | optional body (e.g. `is_deleted:`) |
| `script_create(**body)` | POST | `/project/calltracking/script/create` | |
| `script_update(**body)` | POST | `/project/calltracking/script/update` | |
| `script_delete(id:)` | POST | `/project/calltracking/script/delete` | |
| `phone_list(**body)` | POST | `/project/calltracking/phone/list` | |
| `phone_prefix_list(**body)` | POST | `/project/calltracking/phone/prefix/list` | |
| `phone_create(phones:)` | POST | `/project/calltracking/phone/create` | |
| `phone_buy(prefix:, count:)` | POST | `/project/calltracking/phone/buy` | |
| `phone_update(**body)` | POST | `/project/calltracking/phone/update` | |
| `phone_delete(phones:)` | POST | `/project/calltracking/phone/delete` | phone ids |
| `call_list(**body)` | POST | `/project/calltracking/call/list` | filters, extend, sort, limit, offset |
| `call_update(**body)` | POST | `/project/calltracking/call/update` | |
| `call_delete(ids:)` | POST | `/project/calltracking/call/delete` | |
| `call_file(call_id:)` | POST | `/project/calltracking/call/{id}/file` | binary (MP3) |
| `call_xls_export(period:)` | POST | `/project/calltracking/call/xls/export` | binary (XLS) |
| `data(period:)` | POST | `/project/calltracking/data` | dashboard analytics |
| `phone_call(**body)` | POST | `/project/phone-call` | create call history row |

Examples:

```ruby
Roistat.client.calltracking.phone_list
Roistat.client.calltracking.script_list(is_deleted: 0)
Roistat.client.calltracking.call_list(
  filters: {and: [["date", ">", "2026-01-01T00:00:00+0000"]]},
  limit: 50
)
Roistat.client.calltracking.data(period: period)
audio = Roistat.client.calltracking.call_file(call_id: 1234)
```

### Orders — `client.orders`

Official docs: [orders API](https://help-ru.roistat.com/API/methods/orders/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**body)` | POST | `/project/integration/order/list` |
| `add(orders)` | POST | `/project/add-orders` (JSON array body) |
| `info(order_id:)` | GET | `/project/orders/{id}/info` |
| `external_url(order_id:)` | GET | `/project/orders/{id}/external-url` |
| `status_list(**body)` | POST | `/project/integration/status/list` |
| `set_statuses(statuses)` | POST | `/project/set-statuses` (JSON array body) |
| `custom_fields(**body)` | POST | `/project/analytics/order-custom-fields` |
| `status_update(order_id:, status_id:)` | POST | `/project/integration/order/{id}/status/update` |
| `goal_update(order_id:, **body)` | POST | `/project/integration/order/{id}/goal/update` |
| `update(orders:)` | POST | `/project/integration/order/update` |
| `delete(order_id:)` | POST | `/project/integration/order/{id}/delete` |
| `delete_many(ids:)` | POST | `/project/integration/order/delete` |

Examples:

```ruby
Roistat.client.orders.list(limit: 50)
Roistat.client.orders.status_list
Roistat.client.orders.info(order_id: "order_12345")
Roistat.client.orders.add([
  {id: "1", name: "New order", date_create: "2022-06-19T00:32:12+0000"}
])
```

### Proxy leads — `client.proxy_leads`

Official docs: [proxy leads API](https://help-ru.roistat.com/API/methods/proxy-leads/).
`period` is `YYYY-MM-DD-YYYY-MM-DD` in the query string.

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(period:)` | GET | `/project/proxy-leads` |
| `duplicates(period:)` | GET | `/project/proxy-leads/duplicates` |
| `get(id:)` | GET | `/project/proxy-leads/{id}` |

Examples:

```ruby
Roistat.client.proxy_leads.list(period: "2026-01-01-2026-07-22")
Roistat.client.proxy_leads.get(id: "2")
```

### Leads — `client.leads`

Official docs: [lead management API](https://help-ru.roistat.com/API/methods/lead_management/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**body)` | POST | `/project/leads/lead/list` |
| `status_list(**body)` | POST | `/project/leads/status/list` |
| `create(**body)` | POST | `/project/leads/lead/create` |
| `update(**body)` | POST | `/project/leads/lead/update` |

Examples:

```ruby
Roistat.client.leads.status_list
Roistat.client.leads.list(
  period: {from: "2023-10-17T21:00:00.000Z", to: "2023-11-30T20:59:59.999Z"},
  sort_field: "creation_date",
  limit: 20
)
```

### Managers — `client.managers`

Official docs: [managers API](https://help-ru.roistat.com/API/methods/managers/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**body)` | POST | `/project/integration/manager/list` |
| `add(**body)` | POST | `/project/integration/manager/add` |
| `update(**body)` | POST | `/project/integration/manager/update` |
| `delete(id:)` | POST | `/project/integration/manager/delete` |

Examples:

```ruby
Roistat.client.managers.list
Roistat.client.managers.add(id: "12345", name: "Petrov", email: "a@b.c")
```

### Clients — `client.clients`

Official docs: [clients API](https://help-ru.roistat.com/API/methods/clients/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**body)` | POST | `/project/clients` |
| `import(clients)` | POST | `/project/clients/import` (JSON array body) |
| `detail_feed(client:)` | GET | `/project/clients/detail/feed` (`client` query) |
| `campaign_list(**body)` | POST | `/project/clients/campaign/list` |
| `campaign_contact_list(**body)` | POST | `/project/clients/campaign/contact/list` |

Examples:

```ruby
Roistat.client.clients.list(limit: 100)
Roistat.client.clients.detail_feed(client: "123")
Roistat.client.clients.import([{id: "111", name: "Valera"}])
```

### Visits — `client.visits`

Official docs: [visits API](https://help-ru.roistat.com/API/methods/visit/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**body)` | POST | `/project/site/visit/list` |
| `params_update(**body)` | POST | `/project/site/visit/params/update` |

Examples:

```ruby
Roistat.client.visits.list(limit: 100)
Roistat.client.visits.params_update(visit: "123", roistat_param1: "onlineshop")
```

### Events — `client.events`

Official docs: [events API](https://help-ru.roistat.com/API/methods/events/).
`send_event` avoids shadowing Ruby `Kernel#send`.

| Ruby method | HTTP | Path |
|-------------|------|------|
| `send_event(**body)` | POST | `/project/events/send` |
| `bulk_send(events)` | POST | `/project/events/bulk/send` (JSON array) |
| `add(events)` | POST | `/project/events/add` (JSON array) |
| `log(**params)` | GET | `/project/events/log` (filters as query params) |
| `archive(event_id:, events:)` | POST | `/project/events/meta/{id}/archive` (JSON array) |

Examples:

```ruby
Roistat.client.events.log(name: "Cart")
Roistat.client.events.send_event(name: "Purchase", visit: "100001")
```

### Analytics — `client.analytics`

Official docs: [analytics API](https://help-ru.roistat.com/API/methods/analytics/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `data(**body)` | POST | `/project/analytics/data` |
| `data_export_excel(**body)` | POST | `/project/analytics/data/export/excel` (binary) |
| `metrics_new(**body)` | POST | `/project/analytics/metrics-new` |
| `dimensions(**body)` | POST | `/project/analytics/dimensions` |
| `dimension_values(**body)` | POST | `/project/analytics/dimension-values` |
| `attribution_models(**body)` | POST | `/project/analytics/attribution-models` |
| `list_orders(**body)` | POST | `/project/analytics/list-orders` |
| `custom_metrics_list(**params)` | GET | `/project/analytics/metrics/custom/list` |
| `custom_manual_value_list(**body)` | POST | `/project/analytics/metrics/custom/manual/value/list` |
| `custom_manual_value_add(**body)` | POST | `/project/analytics/metrics/custom/manual/value/add` |
| `custom_manual_value_delete(**body)` | POST | `/project/analytics/metrics/custom/manual/value/delete` |
| `funnel_data(**body)` | POST | `/project/reports/funnel/data` |
| `event_add(**body)` | POST | `/project/analytics/event/add` |

Examples:

```ruby
Roistat.client.analytics.dimensions
Roistat.client.analytics.metrics_new
Roistat.client.analytics.custom_metrics_list
Roistat.client.analytics.data(
  period: {from: "2026-01-01T00:00:00+0300", to: "2026-07-31T23:59:59+0300"},
  metrics: ["visits"],
  dimensions: ["marker_level_1"]
)
```

### Channels — `client.channels`

Official docs: [channels / source costs API](https://help-ru.roistat.com/API/methods/channels/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `source_list(**body)` | POST | `/project/analytics/source/list` |
| `cost_list(**body)` | POST | `/project/analytics/source/cost/list` |
| `cost_add(**body)` | POST | `/project/analytics/source/cost/add` |
| `cost_update(**body)` | POST | `/project/analytics/source/cost/update` |
| `cost_delete(id:)` | POST | `/project/analytics/source/cost/delete` |

Examples:

```ruby
Roistat.client.channels.source_list
Roistat.client.channels.cost_list
```

### Statistics — `client.statistics`

Official docs: [statistics API](https://help-ru.roistat.com/API/methods/statistics/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `get_daily(**body)` | POST | `/project/statistics/get-daily` (`period`: `YYYY-MM-DD-YYYY-MM-DD` in UTC; optional `time_zone`, `channel`) |

Examples:

```ruby
Roistat.client.statistics.get_daily(period: "2026-01-01-2026-07-22")
```

### Indicators — `client.indicators`

Official docs: [health indicators API](https://help-ru.roistat.com/API/methods/indicators/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list` | GET | `/project/health/indicator/list` |
| `run_script(indicator_id:)` | POST | `/project/health/indicator/{id}/run-script` |

Examples:

```ruby
Roistat.client.indicators.list
Roistat.client.indicators.run_script(indicator_id: 7)
```

### Lead hunter — `client.lead_hunter`

Official docs: [lead hunter API](https://help-ru.roistat.com/API/methods/lead-hunter/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**params)` | GET | `/project/lead-hunter/lead/list` (filters as query params) |

Examples:

```ruby
Roistat.client.lead_hunter.list
```

### Email tracking — `client.emailtracking`

Official docs: [email tracking API](https://help-ru.roistat.com/API/methods/emailtracking/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `list(**body)` | POST | `/project/emailtracking/email/list` |
| `attachment(email_id:, attachment_id:)` | GET | `/project/emailtracking/email/{email_id}/attachment/{attachment_id}` (binary) |

Examples:

```ruby
Roistat.client.emailtracking.list(limit: 10)
```

### SMS — `client.sms`

| Ruby method | HTTP | Path |
|-------------|------|------|
| `set_report_enabled(enabled:)` | POST | `/project/set-sms-report-enabled` (`enabled`: `"0"` or `"1"`) |

Examples:

```ruby
Roistat.client.sms.set_report_enabled(enabled: true)
```

### Mediaplan — `client.mediaplan`

Official docs: [mediaplan API](https://help-ru.roistat.com/API/methods/mediaplan/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `target_list(**body)` | POST | `/project/mediaplan/target/list` |
| `target_create(**body)` | POST | `/project/mediaplan/target/create` |
| `target_update(**body)` | POST | `/project/mediaplan/target/update` |
| `target_delete(id:)` | POST | `/project/mediaplan/target/delete` |

Examples:

```ruby
Roistat.client.mediaplan.target_list(
  period: {from: "2026-07-01T00:00:00+0300", to: "2026-07-31T23:59:59+0300"}
)
```

### Speech analytics — `client.speech`

**RU help only.** Official docs: [speech analytics API](https://help-ru.roistat.com/API/methods/speech/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `call_list(**body)` | POST | `/project/speech/call/list` |
| `call_list_export_excel(**body)` | POST | `/project/speech/call/list/export/excel` (binary) |
| `call_add(**body)` | POST | `/project/speech/call/add` |
| `call_comment_update(**body)` | POST | `/project/speech/call/comment/update` |
| `call_operator_update(**body)` | POST | `/project/speech/call/operator/update` |
| `call_transcription_list(**body)` | POST | `/project/speech/call/transcription/list` |
| `dictionary_list(**body)` | POST | `/project/speech/dictionary/list` |
| `dictionary_custom_create(**body)` | POST | `/project/speech/dictionary/custom/create` |
| `dictionary_custom_update(**body)` | POST | `/project/speech/dictionary/custom/update` |
| `dictionary_custom_delete(**body)` | POST | `/project/speech/dictionary/custom/delete` |
| `dictionary_custom_phrase_list(**body)` | POST | `/project/speech/dictionary/custom/phrase/list` |
| `settings_list(**body)` | POST | `/project/speech/settings/list` |
| `settings_update(**body)` | POST | `/project/speech/settings/update` |

Examples:

```ruby
Roistat.client.speech.dictionary_list
Roistat.client.speech.call_list
```

### Cloud PBX (VPBX) — `client.vpbx`

**RU help only.** Official docs: [VPBX API](https://help-ru.roistat.com/API/methods/vpbx/).

| Ruby method | HTTP | Path |
|-------------|------|------|
| `call_list(**body)` | POST | `/project/vpbx/call/list` |
| `operator_list(**body)` | POST | `/project/vpbx/operator/list` |
| `operator_create(**body)` | POST | `/project/vpbx/operator/create` |
| `operator_update(**body)` | POST | `/project/vpbx/operator/update` |
| `operator_deactivate(**body)` | POST | `/project/vpbx/operator/deactivate` |
| `operator_group_list(**body)` | POST | `/project/vpbx/operator/group/list` |
| `operator_group_create(**body)` | POST | `/project/vpbx/operator/group/create` |
| `operator_group_update(**body)` | POST | `/project/vpbx/operator/group/update` |
| `phone_list(**params)` | GET | `/project/vpbx/phone/list` |
| `phone_create(**body)` | POST | `/project/vpbx/phone/create` |
| `phone_update(**body)` | POST | `/project/vpbx/phone/update` |
| `phone_delete(**body)` | POST | `/project/vpbx/phone/delete` |
| `script_list(**params)` | GET | `/project/vpbx/script/list` |
| `script_create(**body)` | POST | `/project/vpbx/script/create` |
| `script_update(**body)` | POST | `/project/vpbx/script/update` |
| `script_delete(**body)` | POST | `/project/vpbx/script/delete` |
| `report_data(**body)` | POST | `/project/vpbx/report/data` |
| `settings_update(**body)` | POST | `/project/vpbx/settings/update` |
| `settings_file_audio_upload(file:, **fields)` | POST | `/project/vpbx/settings/file/audio/upload` (multipart) |

`settings_file_audio_upload` sends `multipart/form-data` via `Client#post_multipart`. Pass an IO or open file as `file:`; other keyword args become form fields.

Examples:

```ruby
Roistat.client.vpbx.phone_list
Roistat.client.vpbx.script_list
```

## Responses

### JSON

Successful JSON responses return the parsed body (usually a Hash with string keys).

### Binary

With `parse: :binary` (billing Excel export, calltracking XLS export, call audio, email attachments, speech call export):

| Body size | Return type |
|-----------|-------------|
| ≤ `binary_tempfile_threshold` (default 1 MiB) | `String` |
| \> threshold | `Tempfile` (caller should close/unlink) |

## Errors

Roistat API errors with `"status": "error"` map to typed exceptions:

| Roistat `error` code | Exception |
|----------------------|-----------|
| `authentication_failed` | `Roistat::AuthenticationError` |
| `authorization_failed` | `Roistat::AuthorizationError` |
| `access_denied` | `Roistat::AccessDeniedError` |
| `request_limit_error` | `Roistat::RateLimitError` |
| other / unknown | `Roistat::Error` |

Invalid local config raises `Roistat::ConfigurationError`.

Error instances may expose:

- `code` — Roistat error code
- `http_status` — HTTP status
- `response_body` — parsed body when available

## Development

```bash
bin/setup
bundle exec rake          # RSpec + RuboCop
# or
mise test
mise lint
```

Install Lefthook once for pre-commit hooks:

```bash
bundle exec lefthook install
```

Interactive console:

```bash
bin/console
```

Release:

```bash
mise release
# or: bundle exec rake release
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alec-c4/roistat.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
