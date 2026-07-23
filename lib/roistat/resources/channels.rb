# frozen_string_literal: true

class Roistat::Resources::Channels < Roistat::Resources::Base
  # POST /project/analytics/source/list
  def source_list(**body)
    client.post("project/analytics/source/list", body: body)
  end

  # POST /project/analytics/source/cost/list
  def cost_list(**body)
    client.post("project/analytics/source/cost/list", body: body)
  end

  # POST /project/analytics/source/cost/add
  def cost_add(**body)
    client.post("project/analytics/source/cost/add", body: body)
  end

  # POST /project/analytics/source/cost/update
  def cost_update(**body)
    client.post("project/analytics/source/cost/update", body: body)
  end

  # POST /project/analytics/source/cost/delete
  def cost_delete(id:)
    client.post("project/analytics/source/cost/delete", body: {id: id})
  end
end
