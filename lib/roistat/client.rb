# frozen_string_literal: true

require "httpx"
require "json"

class Roistat::Client
  attr_reader :api_key, :project, :base_url, :timeout, :open_timeout, :binary_tempfile_threshold

  def initialize(
    api_key:,
    project: nil,
    project_required: true,
    base_url: nil,
    timeout: nil,
    open_timeout: nil,
    binary_tempfile_threshold: nil
  )
    config = Roistat.configuration

    @api_key = api_key
    @project = project
    @project_required = project_required
    @base_url = base_url || config.base_url
    @timeout = timeout || config.timeout
    @open_timeout = open_timeout || config.open_timeout
    @binary_tempfile_threshold = binary_tempfile_threshold || config.binary_tempfile_threshold

    validate_credentials!
  end

  def get(path, params: {}, parse: :json)
    request(:get, path, params: params, parse: parse)
  end

  def post(path, params: {}, body: nil, parse: :json)
    request(:post, path, params: params, body: body, parse: parse)
  end

  def request(method, path, params: {}, body: nil, parse: :json)
    validate_project! if @project_required

    query = params.dup
    query[:project] = project if project && !query.key?(:project) && !query.key?("project")

    headers = {
      "Api-key" => api_key,
      "Accept" => "application/json"
    }

    options = {params: stringify_keys(query), headers: headers}
    if body
      headers["Content-Type"] = "application/json"
      options[:json] = body
    end

    http_response = session.request(method.to_s.upcase, url_for(path), **options)
    Roistat::Response.parse(
      http_response,
      parse: parse,
      binary_tempfile_threshold: binary_tempfile_threshold
    )
  end

  def projects
    @projects ||= Roistat::Resources::Projects.new(self)
  end

  def access
    @access ||= Roistat::Resources::Access.new(self)
  end

  def billing
    @billing ||= Roistat::Resources::Billing.new(self)
  end

  def calltracking
    @calltracking ||= Roistat::Resources::Calltracking.new(self)
  end

  def orders
    @orders ||= Roistat::Resources::Orders.new(self)
  end

  def proxy_leads
    @proxy_leads ||= Roistat::Resources::ProxyLeads.new(self)
  end

  def leads
    @leads ||= Roistat::Resources::Leads.new(self)
  end

  def managers
    @managers ||= Roistat::Resources::Managers.new(self)
  end

  def clients
    @clients ||= Roistat::Resources::Clients.new(self)
  end

  def visits
    @visits ||= Roistat::Resources::Visits.new(self)
  end

  def events
    @events ||= Roistat::Resources::Events.new(self)
  end

  def analytics
    @analytics ||= Roistat::Resources::Analytics.new(self)
  end

  def channels
    @channels ||= Roistat::Resources::Channels.new(self)
  end

  def statistics
    @statistics ||= Roistat::Resources::Statistics.new(self)
  end

  def indicators
    @indicators ||= Roistat::Resources::Indicators.new(self)
  end

  private

  def validate_credentials!
    raise Roistat::ConfigurationError, "api_key must be present" if blank?(api_key)
    validate_project! if @project_required
  end

  def validate_project!
    raise Roistat::ConfigurationError, "project must be present" if blank?(project)
  end

  def blank?(value)
    value.nil? || value.to_s.strip.empty?
  end

  def url_for(path)
    "#{base_url.to_s.chomp("/")}/#{path.to_s.delete_prefix("/")}"
  end

  def session
    @session ||= HTTPX.with(
      timeout: {
        request_timeout: timeout,
        connect_timeout: open_timeout
      }
    )
  end

  def stringify_keys(hash)
    hash.transform_keys(&:to_s)
  end
end
