# frozen_string_literal: true

class Roistat::Resources::Clients < Roistat::Resources::Base
  # POST /project/clients
  def list(**body)
    client.post("project/clients", body: body)
  end

  # POST /project/clients/import — body is a JSON array
  def import(clients)
    client.post("project/clients/import", body: clients)
  end

  # GET /project/clients/detail/feed?client=
  def detail_feed(client:)
    @client.get("project/clients/detail/feed", params: {client: client})
  end

  # POST /project/clients/campaign/list
  def campaign_list(**body)
    client.post("project/clients/campaign/list", body: body)
  end

  # POST /project/clients/campaign/contact/list
  def campaign_contact_list(**body)
    client.post("project/clients/campaign/contact/list", body: body)
  end
end
