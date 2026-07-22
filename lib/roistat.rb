# frozen_string_literal: true

require_relative "roistat/version"
require_relative "roistat/errors"
require_relative "roistat/configuration"
require_relative "roistat/response"
require_relative "roistat/client"

module Roistat::Resources
end

require_relative "roistat/resources/base"
require_relative "roistat/resources/projects"
require_relative "roistat/resources/access"
require_relative "roistat/resources/billing"
require_relative "roistat/resources/calltracking"
require_relative "roistat/resources/orders"
require_relative "roistat/resources/proxy_leads"
require_relative "roistat/resources/leads"
require_relative "roistat/resources/managers"

module Roistat
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
      @client = nil
    end

    def client
      @client ||= Client.new(
        api_key: configuration.api_key,
        project: configuration.project,
        base_url: configuration.base_url,
        timeout: configuration.timeout,
        open_timeout: configuration.open_timeout,
        binary_tempfile_threshold: configuration.binary_tempfile_threshold
      )
    end
  end
end

module Roistat::Generators
end
