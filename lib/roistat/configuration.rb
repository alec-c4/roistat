# frozen_string_literal: true

class Roistat::Configuration
  DEFAULT_BASE_URL = "https://cloud.roistat.com/api/v1"
  DEFAULT_TIMEOUT = 30
  DEFAULT_OPEN_TIMEOUT = 10
  DEFAULT_BINARY_TEMPFILE_THRESHOLD = 1 * 1024 * 1024

  attr_accessor :api_key, :project, :base_url, :timeout, :open_timeout, :binary_tempfile_threshold

  def initialize
    @base_url = DEFAULT_BASE_URL
    @timeout = DEFAULT_TIMEOUT
    @open_timeout = DEFAULT_OPEN_TIMEOUT
    @binary_tempfile_threshold = DEFAULT_BINARY_TEMPFILE_THRESHOLD
  end
end
