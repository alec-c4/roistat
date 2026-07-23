## [0.1.1] — 2026-07-23

### Fixed

- Escape IDs interpolated into request paths (`orders`, `dashboards`, `calltracking`, `events`, `indicators`, `emailtracking`, `proxy_leads`, `widgets`) so values containing `/`, `?`, `#`, or spaces can't corrupt the request path or inject query parameters
- `widgets.data(method: :get)` now forwards extra keyword arguments as query params instead of silently dropping them

### Changed

- Centralized empty-body handling in `Roistat::Client#request`; resource classes now call `client.post` directly instead of a per-class `post`/`post_optional_body` helper

## [0.1.0] — 2026-07-22

### Added

- HTTP client on httpx with `Roistat.configure` / `Roistat.client` and `Roistat::Client`
- Authenticated JSON requests (`Api-key` header + `project` query)
- Typed API errors (`AuthenticationError`, `AuthorizationError`, `AccessDeniedError`, `RateLimitError`)
- Binary response handling (`String` ≤ 1 MiB, otherwise `Tempfile`)
- Rails generator `rails g roistat:install`
- Resource APIs:
  - `projects`, `access`, `billing`
  - `calltracking`
  - `orders`, `proxy_leads`, `leads`, `managers`
  - `clients`, `visits`, `events`
  - `analytics`, `channels`, `statistics`, `indicators`
  - `lead_hunter`, `emailtracking`, `sms`, `mediaplan`, `speech`, `vpbx`
  - `dashboards`, `widgets`; `access.authorized_users` / `access.change`; `projects.counter_list`
- Russian documentation at `docs/ru/README.md` (linked from the root README)
