## [Unreleased]

### Added

- HTTP client platform on httpx with `Roistat.configure` / `Roistat.client` and `Roistat::Client`
- Authenticated JSON requests (`Api-key` header + `project` query)
- Typed API errors (`AuthenticationError`, `AuthorizationError`, `AccessDeniedError`, `RateLimitError`)
- Binary response handling (`String` ≤ 1 MiB, otherwise `Tempfile`)
- Rails generator `rails g roistat:install`

## [0.1.0] - 2026-07-22

- Initial release
