# Roistat

Ruby wrapper for the [Roistat REST API](https://help-ru.roistat.com/API/methods/about/).

The gem sends every request with the `Api-key` header (never as a `key` query param). Project-scoped calls also send `project` in the query string.

## Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Clients](#clients)
- [Low-level HTTP API](#low-level-http-api)
- [Resource APIs](#resource-apis)
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
client.billing
client.calltracking
```

Official parameter details live in the [Roistat API docs](https://help-ru.roistat.com/API/methods/about/).

### Projects — `client.projects`

| Ruby method | HTTP | Path | Auth |
|-------------|------|------|------|
| `list` | GET | `/user/projects` | API key only |
| `create(name:, currency:)` | POST | `/account/project/create` | API key only |
| `modules_list(method: :get)` | GET or POST | `/project/settings/module/list` | API key + project |

Examples:

```ruby
Roistat.client.projects.list
Roistat.client.projects.create(name: "Demo", currency: "RUB")
Roistat.client.projects.modules_list
Roistat.client.projects.modules_list(method: :post)
```

### Access — `client.access`

| Ruby method | HTTP | Path | Auth |
|-------------|------|------|------|
| `user_list` | GET | `/project/permissions/user/list` | API key + project |

Example:

```ruby
Roistat.client.access.user_list
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

## Responses

### JSON

Successful JSON responses return the parsed body (usually a Hash with string keys).

### Binary

With `parse: :binary` (billing Excel export, calltracking XLS export, call audio):

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
