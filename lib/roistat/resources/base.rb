# frozen_string_literal: true

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

  def post_optional_body(path, body)
    if body.nil? || body.empty?
      client.post(path)
    else
      client.post(path, body: body)
    end
  end
end
