# frozen_string_literal: true

class Roistat::Error < StandardError
  attr_reader :code, :http_status, :response_body

  def initialize(message = nil, code: nil, http_status: nil, response_body: nil)
    @code = code
    @http_status = http_status
    @response_body = response_body
    super(message || code || self.class.name)
  end
end

class Roistat::ConfigurationError < Roistat::Error; end
class Roistat::AuthenticationError < Roistat::Error; end
class Roistat::AuthorizationError < Roistat::Error; end
class Roistat::AccessDeniedError < Roistat::Error; end
class Roistat::RateLimitError < Roistat::Error; end
