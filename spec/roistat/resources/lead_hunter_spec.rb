# frozen_string_literal: true

RSpec.describe Roistat::Resources::LeadHunter do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "#list" do
    it "GETs /project/lead-hunter/lead/list with project" do
      stub_request(:get, "#{base_url}/project/lead-hunter/lead/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.lead_hunter.list["status"]).to eq("success")
    end
  end
end
