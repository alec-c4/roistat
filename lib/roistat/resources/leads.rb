# frozen_string_literal: true

class Roistat::Resources::Leads < Roistat::Resources::Base
  # POST /project/leads/lead/list
  def list(**body)
    client.post("project/leads/lead/list", body: body)
  end

  # POST /project/leads/status/list
  def status_list(**body)
    client.post("project/leads/status/list", body: body)
  end

  # POST /project/leads/lead/create
  def create(**body)
    client.post("project/leads/lead/create", body: body)
  end

  # POST /project/leads/lead/update
  def update(**body)
    client.post("project/leads/lead/update", body: body)
  end
end
