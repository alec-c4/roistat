# frozen_string_literal: true

class Roistat::Resources::Access < Roistat::Resources::Base
  # GET /project/permissions/user/list
  def user_list
    client.get("project/permissions/user/list")
  end
end
