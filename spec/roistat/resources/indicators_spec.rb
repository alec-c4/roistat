# frozen_string_literal: true

RSpec.describe Roistat::Resources::Indicators do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "indicators resource" do
    it "#list GETs /project/health/indicator/list" do
      stub_request(:get, "#{base_url}/project/health/indicator/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"indicators" => [], "status" => "success"}.to_json)

      expect(client.indicators.list["status"]).to eq("success")
    end

    it "#run_script POSTs /project/health/indicator/{id}/run-script" do
      stub_request(:post, "#{base_url}/project/health/indicator/7/run-script")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.indicators.run_script(indicator_id: 7)["status"]).to eq("success")
    end
  end
end
