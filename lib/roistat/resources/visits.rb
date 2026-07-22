# frozen_string_literal: true

class Roistat::Resources::Visits < Roistat::Resources::Base
  # POST /project/site/visit/list
  def list(**body)
    post("project/site/visit/list", body: body)
  end

  # POST /project/site/visit/params/update
  def params_update(**body)
    client.post("project/site/visit/params/update", body: body)
  end

  private

  def post(path, body:)
    if body.nil? || body.empty?
      client.post(path)
    else
      client.post(path, body: body)
    end
  end
end
