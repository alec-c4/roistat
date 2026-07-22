# frozen_string_literal: true

RSpec.describe Roistat::Resources::Channels do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "channels resource" do
    it "#source_list POSTs /project/analytics/source/list" do
      stub_request(:post, "#{base_url}/project/analytics/source/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"sources" => [], "status" => "success"}.to_json)

      expect(client.channels.source_list["status"]).to eq("success")
    end

    it "#cost_list POSTs /project/analytics/source/cost/list" do
      stub_request(:post, "#{base_url}/project/analytics/source/cost/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"costs" => [], "status" => "success"}.to_json)

      expect(client.channels.cost_list["status"]).to eq("success")
    end

    it "#cost_add POSTs /project/analytics/source/cost/add" do
      stub_request(:post, "#{base_url}/project/analytics/source/cost/add")
        .with(
          query: {"project" => project},
          body: {"source" => "google", "cost" => 1000, "date" => "2022-01-01"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(
        client.channels.cost_add(source: "google", cost: 1000, date: "2022-01-01")["status"]
      ).to eq("success")
    end

    it "#cost_update POSTs /project/analytics/source/cost/update" do
      stub_request(:post, "#{base_url}/project/analytics/source/cost/update")
        .with(query: {"project" => project}, body: {"id" => "1", "cost" => 2000}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.channels.cost_update(id: "1", cost: 2000)["status"]).to eq("success")
    end

    it "#cost_delete POSTs /project/analytics/source/cost/delete" do
      stub_request(:post, "#{base_url}/project/analytics/source/cost/delete")
        .with(query: {"project" => project}, body: {"id" => "99"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.channels.cost_delete(id: "99")["status"]).to eq("success")
    end
  end
end
