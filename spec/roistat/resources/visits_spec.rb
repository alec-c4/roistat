# frozen_string_literal: true

RSpec.describe Roistat::Resources::Visits do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "visits resource" do
    it "#list POSTs /project/site/visit/list" do
      stub_request(:post, "#{base_url}/project/site/visit/list")
        .with(query: {"project" => project}, body: {"limit" => 10}.to_json)
        .to_return(status: 200, body: {"data" => {"id" => "1"}, "status" => "success"}.to_json)

      expect(client.visits.list(limit: 10)["data"]["id"]).to eq("1")
    end

    it "#params_update POSTs /project/site/visit/params/update" do
      stub_request(:post, "#{base_url}/project/site/visit/params/update")
        .with(
          query: {"project" => project},
          body: {"visit" => "123", "roistat_param1" => "onlineshop"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(
        client.visits.params_update(visit: "123", roistat_param1: "onlineshop")["status"]
      ).to eq("success")
    end
  end
end
