# frozen_string_literal: true

RSpec.describe Roistat::Resources::Mediaplan do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "#target_list" do
    it "POSTs /project/mediaplan/target/list with project" do
      stub_request(:post, "#{base_url}/project/mediaplan/target/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.mediaplan.target_list["status"]).to eq("success")
    end
  end

  describe "#target_create" do
    it "POSTs /project/mediaplan/target/create with body" do
      stub_request(:post, "#{base_url}/project/mediaplan/target/create")
        .with(
          query: {"project" => project},
          body: {"name" => "TV"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.mediaplan.target_create(name: "TV")["status"]).to eq("success")
    end
  end

  describe "#target_update" do
    it "POSTs /project/mediaplan/target/update with body" do
      stub_request(:post, "#{base_url}/project/mediaplan/target/update")
        .with(query: {"project" => project}, body: {"id" => 1, "name" => "Radio"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.mediaplan.target_update(id: 1, name: "Radio")["status"]).to eq("success")
    end
  end

  describe "#target_delete" do
    it "POSTs /project/mediaplan/target/delete with id" do
      stub_request(:post, "#{base_url}/project/mediaplan/target/delete")
        .with(query: {"project" => project}, body: {"id" => 5}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.mediaplan.target_delete(id: 5)["status"]).to eq("success")
    end
  end
end
