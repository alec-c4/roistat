# frozen_string_literal: true

class Roistat::Resources::LeadHunter < Roistat::Resources::Base
  # GET /project/lead-hunter/lead/list
  def list(**params)
    client.get("project/lead-hunter/lead/list", params: params)
  end
end
