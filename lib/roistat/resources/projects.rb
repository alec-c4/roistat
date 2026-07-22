# frozen_string_literal: true

class Roistat::Resources::Projects < Roistat::Resources::Base
  # GET /user/projects — API key only.
  def list
    api_key_client.get("user/projects")
  end

  # POST /account/project/create — API key only.
  def create(name:, currency:)
    api_key_client.post("account/project/create", body: {name: name, currency: currency})
  end

  # GET|POST /project/settings/module/list — project-scoped (help-ru).
  def modules_list(method: :get)
    case method.to_sym
    when :get
      client.get("project/settings/module/list")
    when :post
      client.post("project/settings/module/list")
    else
      raise ArgumentError, "method must be :get or :post"
    end
  end

  # POST /project/settings/counter/list — same product idea as modules_list; listed on help-en.
  def counter_list
    client.post("project/settings/counter/list")
  end
end
