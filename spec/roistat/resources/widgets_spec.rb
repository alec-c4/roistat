# frozen_string_literal: true

RSpec.describe Roistat::Resources::Widgets do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "widgets resource" do
    describe "#data" do
      it "POSTs /project/widget/{widgetId}/data by default" do
        stub_request(:post, "#{base_url}/project/widget/9/data")
          .with(
            query: {"project" => project},
            headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
            body: {"period" => "2026-01-01-2026-01-31"}.to_json
          )
          .to_return(status: 200, body: {"status" => "success", "data" => {}}.to_json)

        response = client.widgets.data(widget_id: 9, period: "2026-01-01-2026-01-31")

        expect(response["status"]).to eq("success")
      end

      it "supports GET when method: :get" do
        stub_request(:get, "#{base_url}/project/widget/9/data")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        client.widgets.data(widget_id: 9, method: :get)

        expect(WebMock).to have_requested(:get, "#{base_url}/project/widget/9/data")
          .with(query: {"project" => project})
      end
    end
  end
end
