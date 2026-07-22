# frozen_string_literal: true

class Roistat::Resources::Managers < Roistat::Resources::Base
  # POST /project/integration/manager/list
  def list(**body)
    post("project/integration/manager/list", body: body)
  end

  # POST /project/integration/manager/add
  def add(**body)
    client.post("project/integration/manager/add", body: body)
  end

  # POST /project/integration/manager/update
  def update(**body)
    client.post("project/integration/manager/update", body: body)
  end

  # POST /project/integration/manager/delete
  def delete(id:)
    client.post("project/integration/manager/delete", body: {id: id})
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
