# frozen_string_literal: true

require "erb"

class Roistat::Resources::Base
  attr_reader :client

  def initialize(client)
    @client = client
  end

  private

  def api_key_client
    @api_key_client ||= Roistat::Client.new(
      api_key: client.api_key,
      project: nil,
      project_required: false,
      base_url: client.base_url,
      timeout: client.timeout,
      open_timeout: client.open_timeout,
      binary_tempfile_threshold: client.binary_tempfile_threshold
    )
  end

  # Escapes a value for safe interpolation into a URL path segment (IDs may
  # be arbitrary external strings, e.g. CRM order ids), so characters like
  # "/", "?", "#" can't alter the request path or inject query parameters.
  def escape_path_segment(value)
    ERB::Util.url_encode(value.to_s)
  end
end
