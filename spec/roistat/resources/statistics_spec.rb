# frozen_string_literal: true

RSpec.describe Roistat::Resources::Statistics do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "statistics resource" do
    it "#get_daily POSTs /project/statistics/get-daily with period in body" do
      period = "2026-01-01-2026-07-22"
      stub_request(:post, "#{base_url}/project/statistics/get-daily")
        .with(
          query: {"project" => project},
          headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
          body: {"period" => period}.to_json
        )
        .to_return(status: 200, body: {"data" => [], "status" => "success"}.to_json)

      expect(client.statistics.get_daily(period: period)["status"]).to eq("success")
    end
  end
end
