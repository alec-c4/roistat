# frozen_string_literal: true

class Roistat::Resources::Indicators < Roistat::Resources::Base
  # GET /project/health/indicator/list
  def list
    client.get("project/health/indicator/list")
  end

  # POST /project/health/indicator/{indicatorId}/run-script
  def run_script(indicator_id:)
    client.post("project/health/indicator/#{escape_path_segment(indicator_id)}/run-script")
  end
end
