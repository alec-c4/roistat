# frozen_string_literal: true

class Roistat::Resources::Dashboards < Roistat::Resources::Base
  # GET /project/dashboards
  def list
    client.get("project/dashboards")
  end

  # GET /project/dashboards/{dashboardId}/widgets
  def widgets(dashboard_id:)
    client.get("project/dashboards/#{dashboard_id}/widgets")
  end
end
