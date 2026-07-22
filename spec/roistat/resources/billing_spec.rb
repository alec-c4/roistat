# frozen_string_literal: true

RSpec.describe Roistat::Resources::Billing do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }
  let(:period) { {from: "2022-01-01T00:00:00+0300", to: "2022-07-31T23:59:59+0300"} }

  describe "billing resource" do
    describe "#transactions_list" do
      it "POSTs /user/billing/transactions/list with project and period" do
        stub_request(:post, "#{base_url}/user/billing/transactions/list")
          .with(
            query: {"project" => project},
            headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
            body: {"period" => {"from" => period[:from], "to" => period[:to]}}.to_json
          )
          .to_return(
            status: 200,
            body: {"data" => [{"type" => "topup", "sum" => 1000}], "status" => "success"}.to_json
          )

        response = client.billing.transactions_list(period: period)

        expect(response["status"]).to eq("success")
        expect(response["data"].first["type"]).to eq("topup")
      end
    end

    describe "#transactions_export_excel" do
      it "POSTs export endpoint and returns binary body" do
        excel = "PK\x03\x04fake-xlsx"
        stub_request(:post, "#{base_url}/user/billing/transactions/list/export/excel")
          .with(
            query: {"project" => project},
            headers: {"Api-key" => api_key},
            body: {"period" => {"from" => period[:from], "to" => period[:to]}}.to_json
          )
          .to_return(
            status: 200,
            body: excel,
            headers: {
              "Content-Type" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              "Content-Length" => excel.bytesize.to_s
            }
          )

        result = client.billing.transactions_export_excel(period: period)

        expect(result).to eq(excel)
        expect(result).to be_a(String)
      end
    end
  end
end
