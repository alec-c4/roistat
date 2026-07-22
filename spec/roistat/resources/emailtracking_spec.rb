# frozen_string_literal: true

RSpec.describe Roistat::Resources::Emailtracking do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "#list" do
    it "POSTs /project/emailtracking/email/list with project" do
      stub_request(:post, "#{base_url}/project/emailtracking/email/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.emailtracking.list["status"]).to eq("success")
    end
  end

  describe "#attachment" do
    it "GETs /project/emailtracking/email/{id}/attachment/{id} as binary" do
      stub_request(:get, "#{base_url}/project/emailtracking/email/10/attachment/20")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: "PDFDATA", headers: {"Content-Type" => "application/pdf"})

      result = client.emailtracking.attachment(email_id: 10, attachment_id: 20)

      expect(result).to eq("PDFDATA")
    end
  end
end
