# frozen_string_literal: true

class Roistat::Resources::Statistics < Roistat::Resources::Base
  # POST /project/statistics/get-daily
  def get_daily(**body)
    client.post("project/statistics/get-daily", body: body)
  end
end
