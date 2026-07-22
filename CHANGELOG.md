## [0.1.0] — Unreleased

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
