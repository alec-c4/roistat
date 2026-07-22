# frozen_string_literal: true

RSpec.describe Roistat::Resources::Leads do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }
  let(:period) { {from: "2022-11-08T21:00:00.000Z", to: "2023-11-09T20:59:59.999Z"} }

  describe "leads resource" do
    it "#list POSTs /project/leads/lead/list" do
      stub_request(:post, "#{base_url}/project/leads/lead/list")
        .with(
          query: {"project" => project},
          body: {
            "period" => {"from" => period[:from], "to" => period[:to]},
            "sort_field" => "creation_date"
          }.to_json
        )
        .to_return(status: 200, body: {"leads" => [{"id" => "10"}], "status" => "success"}.to_json)

      response = client.leads.list(period: period, sort_field: "creation_date")

      expect(response["leads"].first["id"]).to eq("10")
    end

    it "#status_list POSTs /project/leads/status/list" do
      stub_request(:post, "#{base_url}/project/leads/status/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"data" => [{"id" => "0"}], "status" => "success"}.to_json)

      expect(client.leads.status_list["data"].first["id"]).to eq("0")
    end

    it "#create POSTs /project/leads/lead/create" do
      stub_request(:post, "#{base_url}/project/leads/lead/create")
        .with(
          query: {"project" => project},
          body: {
            "creation_date" => "2023-02-22T08:05:35.569Z",
            "name" => "Ivan",
            "status" => "1",
            "title" => "New"
          }.to_json
        )
        .to_return(status: 200, body: {"lead_id" => "2", "status" => "success"}.to_json)

      response = client.leads.create(
        creation_date: "2023-02-22T08:05:35.569Z",
        name: "Ivan",
        status: "1",
        title: "New"
      )

      expect(response["lead_id"]).to eq("2")
    end

    it "#update POSTs /project/leads/lead/update" do
      stub_request(:post, "#{base_url}/project/leads/lead/update")
        .with(query: {"project" => project}, body: {"id" => "8", "name" => "Mikhail"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.leads.update(id: "8", name: "Mikhail")["status"]).to eq("success")
    end
  end
end
