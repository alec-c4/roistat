# frozen_string_literal: true

RSpec.describe Roistat::Resources::ProxyLeads do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }
  let(:period) { "2021-07-07-2021-09-24" }

  describe "proxy_leads resource" do
    it "#list GETs /project/proxy-leads with period" do
      stub_request(:get, "#{base_url}/project/proxy-leads")
        .with(query: {"project" => project, "period" => period}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"ProxyLeads" => [{"id" => "1"}], "status" => "success"}.to_json)

      expect(client.proxy_leads.list(period: period)["ProxyLeads"].first["id"]).to eq("1")
    end

    it "#duplicates GETs /project/proxy-leads/duplicates with period" do
      stub_request(:get, "#{base_url}/project/proxy-leads/duplicates")
        .with(query: {"project" => project, "period" => period})
        .to_return(status: 200, body: {"ProxyLeads" => [], "status" => "success"}.to_json)

      expect(client.proxy_leads.duplicates(period: period)["status"]).to eq("success")
    end

    it "#get GETs /project/proxy-leads/{id}" do
      stub_request(:get, "#{base_url}/project/proxy-leads/2")
        .with(query: {"project" => project})
        .to_return(status: 200, body: {"ProxyLead" => {"id" => "2"}, "status" => "success"}.to_json)

      expect(client.proxy_leads.get(id: "2")["ProxyLead"]["id"]).to eq("2")
    end
  end
end
