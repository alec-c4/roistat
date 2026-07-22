# frozen_string_literal: true

RSpec.describe Roistat::Resources::Dashboards do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "dashboards resource" do
    it "#list GETs /project/dashboards" do
      stub_request(:get, "#{base_url}/project/dashboards")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(
          status: 200,
          body: {"data" => [{"id" => 1, "name" => "Main"}], "status" => "success"}.to_json
        )

      response = client.dashboards.list

      expect(response["status"]).to eq("success")
      expect(response["data"].first["id"]).to eq(1)
    end

    it "#widgets GETs /project/dashboards/{dashboardId}/widgets" do
      stub_request(:get, "#{base_url}/project/dashboards/42/widgets")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(
          status: 200,
          body: {"data" => [{"id" => 7}], "status" => "success"}.to_json
        )

      response = client.dashboards.widgets(dashboard_id: 42)

      expect(response["data"].first["id"]).to eq(7)
    end
  end
end
