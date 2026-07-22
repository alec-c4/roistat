# frozen_string_literal: true

class Roistat::Resources::Access < Roistat::Resources::Base
  # GET /project/permissions/user/list — help-ru.
  def user_list
    client.get("project/permissions/user/list")
  end

  # GET|POST /project/access/get-authorized-users — help-en.
  def authorized_users(method: :get)
    case method.to_sym
    when :get
      client.get("project/access/get-authorized-users")
    when :post
      client.post("project/access/get-authorized-users")
    else
      raise ArgumentError, "method must be :get or :post"
    end
  end

  # POST /project/access/change — help-en.
  def change(**body)
    client.post("project/access/change", body: body)
  end
end
