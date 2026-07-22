# frozen_string_literal: true

RSpec.describe Roistat::Resources::Projects do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "projects resource" do
    describe "#list" do
      it "GETs /user/projects with Api-key only" do
        stub_request(:get, "#{base_url}/user/projects")
          .with(headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: {"projects" => [{"id" => 111, "name" => "project1"}], "status" => "success"}.to_json
          )

        response = client.projects.list

        expect(response["status"]).to eq("success")
        expect(response["projects"].first["id"]).to eq(111)
        expect(WebMock).not_to have_requested(:get, /project=/)
      end
    end

    describe "#create" do
      it "POSTs /account/project/create with name and currency" do
        stub_request(:post, "#{base_url}/account/project/create")
          .with(
            headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
            body: {"name" => "Test", "currency" => "RUB"}.to_json
          )
          .to_return(
            status: 200,
            body: {"data" => {"project_id" => 123}}.to_json
          )

        response = client.projects.create(name: "Test", currency: "RUB")

        expect(response.dig("data", "project_id")).to eq(123)
      end
    end

    describe "#modules_list" do
      it "GETs /project/settings/module/list with project" do
        stub_request(:get, "#{base_url}/project/settings/module/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: {"data" => [{"id" => "qwerty123456"}]}.to_json
          )

        response = client.projects.modules_list

        expect(response["data"].first["id"]).to eq("qwerty123456")
      end

      it "supports POST when method: :post" do
        stub_request(:post, "#{base_url}/project/settings/module/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(status: 200, body: {"data" => []}.to_json)

        client.projects.modules_list(method: :post)

        expect(WebMock).to have_requested(:post, "#{base_url}/project/settings/module/list")
          .with(query: {"project" => project})
      end
    end

    describe "#counter_list" do
      it "POSTs /project/settings/counter/list" do
        stub_request(:post, "#{base_url}/project/settings/counter/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: {"data" => [{"id" => "counter-1"}], "status" => "success"}.to_json
          )

        response = client.projects.counter_list

        expect(response["data"].first["id"]).to eq("counter-1")
      end
    end
  end
end
