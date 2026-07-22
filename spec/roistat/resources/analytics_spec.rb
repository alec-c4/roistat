# frozen_string_literal: true

RSpec.describe Roistat::Resources::Analytics do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }
  let(:period) { {from: "2022-01-01T00:00:00+0300", to: "2022-07-31T23:59:59+0300"} }

  describe "analytics resource" do
    it "#data POSTs /project/analytics/data" do
      stub_request(:post, "#{base_url}/project/analytics/data")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"data" => [], "status" => "success"}.to_json)

      expect(client.analytics.data["status"]).to eq("success")
    end

    it "#data_export_excel POSTs /project/analytics/data/export/excel and returns binary" do
      excel = "PK\x03\x04fake-xlsx"
      stub_request(:post, "#{base_url}/project/analytics/data/export/excel")
        .with(
          query: {"project" => project},
          headers: {"Api-key" => api_key},
          body: {"period" => period}.to_json
        )
        .to_return(
          status: 200,
          body: excel,
          headers: {"Content-Length" => excel.bytesize.to_s}
        )

      result = client.analytics.data_export_excel(period: period)

      expect(result).to eq(excel)
      expect(result).to be_a(String)
    end

    it "#metrics_new POSTs /project/analytics/metrics-new" do
      stub_request(:post, "#{base_url}/project/analytics/metrics-new")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"metrics" => [], "status" => "success"}.to_json)

      expect(client.analytics.metrics_new["status"]).to eq("success")
    end

    it "#dimensions POSTs /project/analytics/dimensions" do
      stub_request(:post, "#{base_url}/project/analytics/dimensions")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"dimensions" => [], "status" => "success"}.to_json)

      expect(client.analytics.dimensions["status"]).to eq("success")
    end

    it "#dimension_values POSTs /project/analytics/dimension-values" do
      stub_request(:post, "#{base_url}/project/analytics/dimension-values")
        .with(
          query: {"project" => project},
          body: {"dimension" => "marker_level_1"}.to_json
        )
        .to_return(status: 200, body: {"values" => [], "status" => "success"}.to_json)

      expect(client.analytics.dimension_values(dimension: "marker_level_1")["status"]).to eq("success")
    end

    it "#attribution_models POSTs /project/analytics/attribution-models" do
      stub_request(:post, "#{base_url}/project/analytics/attribution-models")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"models" => [], "status" => "success"}.to_json)

      expect(client.analytics.attribution_models["status"]).to eq("success")
    end

    it "#list_orders POSTs /project/analytics/list-orders" do
      stub_request(:post, "#{base_url}/project/analytics/list-orders")
        .with(query: {"project" => project}, body: {"limit" => 10}.to_json)
        .to_return(status: 200, body: {"orders" => [], "status" => "success"}.to_json)

      expect(client.analytics.list_orders(limit: 10)["status"]).to eq("success")
    end

    it "#custom_metrics_list GETs /project/analytics/metrics/custom/list" do
      stub_request(:get, "#{base_url}/project/analytics/metrics/custom/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"metrics" => [], "status" => "success"}.to_json)

      expect(client.analytics.custom_metrics_list["status"]).to eq("success")
    end

    it "#custom_manual_value_list POSTs /project/analytics/metrics/custom/manual/value/list" do
      stub_request(:post, "#{base_url}/project/analytics/metrics/custom/manual/value/list")
        .with(query: {"project" => project}, body: {"metric_id" => "1"}.to_json)
        .to_return(status: 200, body: {"values" => [], "status" => "success"}.to_json)

      expect(client.analytics.custom_manual_value_list(metric_id: "1")["status"]).to eq("success")
    end

    it "#custom_manual_value_add POSTs /project/analytics/metrics/custom/manual/value/add" do
      stub_request(:post, "#{base_url}/project/analytics/metrics/custom/manual/value/add")
        .with(
          query: {"project" => project},
          body: {"metric_id" => "1", "value" => 100, "date" => "2022-01-01"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(
        client.analytics.custom_manual_value_add(metric_id: "1", value: 100, date: "2022-01-01")["status"]
      ).to eq("success")
    end

    it "#custom_manual_value_delete POSTs /project/analytics/metrics/custom/manual/value/delete" do
      stub_request(:post, "#{base_url}/project/analytics/metrics/custom/manual/value/delete")
        .with(query: {"project" => project}, body: {"id" => "42"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.analytics.custom_manual_value_delete(id: "42")["status"]).to eq("success")
    end

    it "#funnel_data POSTs /project/reports/funnel/data" do
      stub_request(:post, "#{base_url}/project/reports/funnel/data")
        .with(query: {"project" => project}, body: {"funnel_id" => "1"}.to_json)
        .to_return(status: 200, body: {"data" => [], "status" => "success"}.to_json)

      expect(client.analytics.funnel_data(funnel_id: "1")["status"]).to eq("success")
    end

    it "#event_add POSTs /project/analytics/event/add" do
      stub_request(:post, "#{base_url}/project/analytics/event/add")
        .with(
          query: {"project" => project},
          body: {"name" => "Purchase", "visit" => "100001"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.analytics.event_add(name: "Purchase", visit: "100001")["status"]).to eq("success")
    end
  end
end
