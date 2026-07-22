# frozen_string_literal: true

RSpec.describe Roistat::Resources::Sms do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "#set_report_enabled" do
    it "POSTs /project/set-sms-report-enabled with enabled flag" do
      stub_request(:post, "#{base_url}/project/set-sms-report-enabled")
        .with(
          query: {"project" => project},
          headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
          body: {"enabled" => "1"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.sms.set_report_enabled(enabled: true)["status"]).to eq("success")
    end
  end
end
