# frozen_string_literal: true

require "json"
require "tempfile"

class Roistat::Response
  ERROR_MAP = {
    "authentication_failed" => Roistat::AuthenticationError,
    "authorization_failed" => Roistat::AuthorizationError,
    "access_denied" => Roistat::AccessDeniedError,
    "request_limit_error" => Roistat::RateLimitError
  }.freeze

  def self.parse(http_response, parse:, binary_tempfile_threshold:)
    new(http_response, parse: parse, binary_tempfile_threshold: binary_tempfile_threshold).parse
  end

  def initialize(http_response, parse:, binary_tempfile_threshold:)
    @http_response = http_response
    @parse = parse
    @binary_tempfile_threshold = binary_tempfile_threshold
  end

  def parse
    raise_transport_error! if transport_failure?

    body = @http_response.body.to_s
    return parse_binary(body) if @parse == :binary

    parsed = parse_json(body)
    raise_api_error!(parsed) if api_error?(parsed)
    parsed
  end

  private

  def transport_failure?
    return false unless @http_response.respond_to?(:error) && @http_response.error

    # HTTP status errors (4xx/5xx) still expose a body — map them via JSON.
    !@http_response.respond_to?(:status) || @http_response.status.nil?
  end

  def raise_transport_error!
    raise Roistat::Error, @http_response.error.message
  end

  def parse_json(body)
    return {} if body.nil? || body.empty?

    JSON.parse(body)
  rescue JSON::ParserError => e
    raise Roistat::Error, "Invalid JSON response: #{e.message}"
  end

  def api_error?(parsed)
    parsed.is_a?(Hash) && parsed["status"].to_s == "error"
  end

  def raise_api_error!(parsed)
    code = parsed["error"].to_s
    error_class = ERROR_MAP.fetch(code, Roistat::Error)
    raise error_class.new(
      "Roistat API error: #{code}",
      code: code,
      http_status: @http_response.status,
      response_body: parsed
    )
  end

  def parse_binary(body)
    size = content_length || body.bytesize
    return body if size <= @binary_tempfile_threshold

    tempfile = Tempfile.new(["roistat", ".bin"], binmode: true)
    tempfile.write(body)
    tempfile.rewind
    tempfile
  end

  def content_length
    headers = @http_response.headers
    value = headers["content-length"] || headers["Content-Length"]
    Integer(value) if value
  rescue ArgumentError, TypeError
    nil
  end
end
