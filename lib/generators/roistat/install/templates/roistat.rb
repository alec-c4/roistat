# frozen_string_literal: true

Roistat.configure do |config|
  # Required for project-scoped API calls.
  config.api_key = ENV.fetch("ROISTAT_API_KEY")
  config.project = ENV.fetch("ROISTAT_PROJECT_ID")

  # Optional overrides.
  # config.base_url = ENV.fetch("ROISTAT_BASE_URL", "https://cloud.roistat.com/api/v1")
  # config.timeout = ENV.fetch("ROISTAT_TIMEOUT", 30).to_i
  # config.open_timeout = ENV.fetch("ROISTAT_OPEN_TIMEOUT", 10).to_i
  # config.binary_tempfile_threshold = ENV.fetch("ROISTAT_BINARY_TEMPFILE_THRESHOLD", 1_048_576).to_i
end
