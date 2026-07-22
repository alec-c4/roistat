# frozen_string_literal: true

RSpec.describe Roistat::Client do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }

  describe "construction" do
    it "stores credentials when valid" do
      client = described_class.new(api_key: api_key, project: project)

      expect(client.api_key).to eq(api_key)
      expect(client.project).to eq(project)
    end

    it "raises when api_key is blank" do
      expect {
        described_class.new(api_key: " ", project: project)
      }.to raise_error(Roistat::ConfigurationError, /api_key/)
    end

    it "raises when project is blank for a project-scoped client" do
      expect {
        described_class.new(api_key: api_key, project: "")
      }.to raise_error(Roistat::ConfigurationError, /project/)
    end

    it "allows blank project when project_required is false" do
      client = described_class.new(api_key: api_key, project: nil, project_required: false)

      expect(client.api_key).to eq(api_key)
      expect(client.project).to be_nil
    end
  end

  describe "global vs explicit client" do
    before do
      Roistat.configure do |config|
        config.api_key = "global-key"
        config.project = "999"
      end
    end

    it "builds Roistat.client from global configuration" do
      client = Roistat.client

      expect(client.api_key).to eq("global-key")
      expect(client.project).to eq("999")
    end

    it "lets an explicit client keep its own credentials" do
      client = described_class.new(api_key: api_key, project: project)

      expect(client.api_key).to eq(api_key)
      expect(client.project).to eq(project)
      expect(Roistat.client.api_key).to eq("global-key")
    end
  end

  describe "authenticated JSON requests" do
    subject(:client) { described_class.new(api_key: api_key, project: project) }

    it "sends Api-key header, project query, and JSON Accept" do
      stub_request(:get, "#{base_url}/project/calltracking/phone/list")
        .with(
          query: {"project" => project},
          headers: {
            "Api-key" => api_key,
            "Accept" => "application/json"
          }
        )
        .to_return(
          status: 200,
          body: {"status" => "success", "data" => []}.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      response = client.get("project/calltracking/phone/list")

      expect(response).to eq("status" => "success", "data" => [])
      expect(WebMock).to have_requested(:get, "#{base_url}/project/calltracking/phone/list")
        .with(query: {"project" => project})
    end

    it "does not put the API key in the query string" do
      stub_request(:get, "#{base_url}/project/calltracking/phone/list")
        .with(query: hash_including("project" => project))
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      client.get("project/calltracking/phone/list")

      expect(WebMock).not_to have_requested(:get, /[?&]key=/)
    end

    it "posts JSON body" do
      stub_request(:post, "#{base_url}/project/events/send")
        .with(
          query: {"project" => project},
          headers: {
            "Api-key" => api_key,
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          },
          body: {"name" => "purchase"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      response = client.post("project/events/send", body: {name: "purchase"})

      expect(response).to eq("status" => "success")
    end
  end

  describe "account-level requests without project" do
    subject(:client) { described_class.new(api_key: api_key, project: nil, project_required: false) }

    it "omits project query when not configured" do
      stub_request(:get, "#{base_url}/user/projects")
        .with(headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"projects" => [], "status" => "success"}.to_json)

      response = client.get("user/projects")

      expect(response["status"]).to eq("success")
      expect(WebMock).to have_requested(:get, "#{base_url}/user/projects")
      expect(WebMock).not_to have_requested(:get, /project=/)
    end
  end

  describe "error mapping" do
    subject(:client) { described_class.new(api_key: api_key, project: project) }

    {
      "authentication_failed" => Roistat::AuthenticationError,
      "authorization_failed" => Roistat::AuthorizationError,
      "access_denied" => Roistat::AccessDeniedError,
      "request_limit_error" => Roistat::RateLimitError
    }.each do |code, error_class|
      it "raises #{error_class} for #{code}" do
        stub_request(:get, "#{base_url}/project/calltracking/phone/list")
          .with(query: {"project" => project})
          .to_return(
            status: 401,
            body: {"status" => "error", "error" => code}.to_json,
            headers: {"Content-Type" => "application/json"}
          )

        expect {
          client.get("project/calltracking/phone/list")
        }.to raise_error(error_class, /#{code}/)
      end
    end

    it "raises Roistat::Error for unknown API errors" do
      stub_request(:get, "#{base_url}/project/calltracking/phone/list")
        .with(query: {"project" => project})
        .to_return(
          status: 400,
          body: {"status" => "error", "error" => "unknown_error"}.to_json
        )

      expect {
        client.get("project/calltracking/phone/list")
      }.to raise_error(Roistat::Error, /unknown_error/)
    end
  end

  describe "binary responses" do
    subject(:client) { described_class.new(api_key: api_key, project: project) }

    it "returns a String for small binary bodies" do
      body = "small-binary"
      stub_request(:get, "#{base_url}/project/calltracking/call/1/file")
        .with(query: {"project" => project})
        .to_return(
          status: 200,
          body: body,
          headers: {"Content-Type" => "audio/mpeg", "Content-Length" => body.bytesize.to_s}
        )

      result = client.get("project/calltracking/call/1/file", parse: :binary)

      expect(result).to eq(body)
      expect(result).to be_a(String)
    end

    it "returns a Tempfile for large binary bodies" do
      body = "x" * ((1 * 1024 * 1024) + 1)
      stub_request(:get, "#{base_url}/project/calltracking/call/1/file")
        .with(query: {"project" => project})
        .to_return(
          status: 200,
          body: body,
          headers: {"Content-Type" => "application/octet-stream", "Content-Length" => body.bytesize.to_s}
        )

      result = client.get("project/calltracking/call/1/file", parse: :binary)

      expect(result).to be_a(Tempfile)
      expect(result.read).to eq(body)
      result.close!
    end
  end
end
