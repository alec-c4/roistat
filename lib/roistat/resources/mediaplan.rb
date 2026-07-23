# frozen_string_literal: true

class Roistat::Resources::Mediaplan < Roistat::Resources::Base
  # POST /project/mediaplan/target/list
  def target_list(**body)
    client.post("project/mediaplan/target/list", body: body)
  end

  # POST /project/mediaplan/target/create
  def target_create(**body)
    client.post("project/mediaplan/target/create", body: body)
  end

  # POST /project/mediaplan/target/update
  def target_update(**body)
    client.post("project/mediaplan/target/update", body: body)
  end

  # POST /project/mediaplan/target/delete
  def target_delete(id:)
    client.post("project/mediaplan/target/delete", body: {id: id})
  end
end
