# frozen_string_literal: true

RSpec.describe Roistat::Resources::Managers do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "managers resource" do
    it "#list POSTs /project/integration/manager/list" do
      stub_request(:post, "#{base_url}/project/integration/manager/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"data" => [{"id" => "1"}], "status" => "success"}.to_json)

      expect(client.managers.list["data"].first["id"]).to eq("1")
    end

    it "#add POSTs /project/integration/manager/add" do
      stub_request(:post, "#{base_url}/project/integration/manager/add")
        .with(
          query: {"project" => project},
          body: {"id" => "12345", "name" => "Petrov", "email" => "a@b.c"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(
        client.managers.add(id: "12345", name: "Petrov", email: "a@b.c")["status"]
      ).to eq("success")
    end

    it "#update POSTs /project/integration/manager/update" do
      stub_request(:post, "#{base_url}/project/integration/manager/update")
        .with(query: {"project" => project}, body: {"id" => "12345", "email" => "x@y.z"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.managers.update(id: "12345", email: "x@y.z")["status"]).to eq("success")
    end

    it "#delete POSTs /project/integration/manager/delete" do
      stub_request(:post, "#{base_url}/project/integration/manager/delete")
        .with(query: {"project" => project}, body: {"id" => "12345"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.managers.delete(id: "12345")["status"]).to eq("success")
    end
  end
end
