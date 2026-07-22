# frozen_string_literal: true

RSpec.describe Roistat::Resources::Clients do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "clients resource" do
    it "#list POSTs /project/clients" do
      stub_request(:post, "#{base_url}/project/clients")
        .with(query: {"project" => project}, body: {"limit" => 10}.to_json)
        .to_return(status: 200, body: {"data" => [{"id" => "1"}], "status" => "success"}.to_json)

      expect(client.clients.list(limit: 10)["data"].first["id"]).to eq("1")
    end

    it "#import POSTs /project/clients/import with array body" do
      clients = [{"id" => "111", "name" => "Valera"}]
      stub_request(:post, "#{base_url}/project/clients/import")
        .with(query: {"project" => project}, body: clients.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.clients.import(clients)["status"]).to eq("success")
    end

    it "#detail_feed GETs /project/clients/detail/feed with client query" do
      stub_request(:get, "#{base_url}/project/clients/detail/feed")
        .with(query: {"project" => project, "client" => "123"}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"feed" => [], "status" => "success"}.to_json)

      expect(client.clients.detail_feed(client: "123")["status"]).to eq("success")
    end

    it "#campaign_list POSTs /project/clients/campaign/list" do
      stub_request(:post, "#{base_url}/project/clients/campaign/list")
        .with(query: {"project" => project}, body: {"limit" => 100}.to_json)
        .to_return(status: 200, body: {"data" => [], "status" => "success"}.to_json)

      expect(client.clients.campaign_list(limit: 100)["status"]).to eq("success")
    end

    it "#campaign_contact_list POSTs /project/clients/campaign/contact/list" do
      stub_request(:post, "#{base_url}/project/clients/campaign/contact/list")
        .with(
          query: {"project" => project},
          body: {"metric_ids" => ["sent"], "campaign_ids" => [2]}.to_json
        )
        .to_return(status: 200, body: {"data" => [], "status" => "success"}.to_json)

      expect(
        client.clients.campaign_contact_list(metric_ids: ["sent"], campaign_ids: [2])["status"]
      ).to eq("success")
    end
  end
end
