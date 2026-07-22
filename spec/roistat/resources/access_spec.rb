# frozen_string_literal: true

RSpec.describe Roistat::Resources::Access do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "access resource" do
    describe "#user_list" do
      it "GETs /project/permissions/user/list" do
        stub_request(:get, "#{base_url}/project/permissions/user/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: {
              "data" => [{"email" => "email1@mail.ru", "granted_permissions" => ["access_analytics_base_read"]}],
              "total" => 1,
              "status" => "success"
            }.to_json
          )

        response = client.access.user_list

        expect(response["status"]).to eq("success")
        expect(response["data"].first["email"]).to eq("email1@mail.ru")
      end
    end
  end
end
