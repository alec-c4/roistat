# frozen_string_literal: true

RSpec.describe Roistat::Resources::Speech do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "#call_list" do
    it "POSTs /project/speech/call/list with project" do
      stub_request(:post, "#{base_url}/project/speech/call/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.speech.call_list["status"]).to eq("success")
    end
  end

  describe "#call_list_export_excel" do
    it "POSTs /project/speech/call/list/export/excel as binary" do
      stub_request(:post, "#{base_url}/project/speech/call/list/export/excel")
        .with(query: {"project" => project}, body: {"period" => {"from" => "a", "to" => "b"}}.to_json)
        .to_return(status: 200, body: "XLSX")

      result = client.speech.call_list_export_excel(period: {from: "a", to: "b"})

      expect(result).to eq("XLSX")
    end
  end

  describe "#call_add" do
    it "POSTs /project/speech/call/add with body" do
      stub_request(:post, "#{base_url}/project/speech/call/add")
        .with(query: {"project" => project}, body: {"call_id" => 1}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.call_add(call_id: 1)["status"]).to eq("success")
    end
  end

  describe "#call_comment_update" do
    it "POSTs /project/speech/call/comment/update with body" do
      stub_request(:post, "#{base_url}/project/speech/call/comment/update")
        .with(query: {"project" => project}, body: {"id" => 1, "comment" => "ok"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.call_comment_update(id: 1, comment: "ok")["status"]).to eq("success")
    end
  end

  describe "#call_operator_update" do
    it "POSTs /project/speech/call/operator/update with body" do
      stub_request(:post, "#{base_url}/project/speech/call/operator/update")
        .with(query: {"project" => project}, body: {"id" => 1, "operator_id" => 2}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.call_operator_update(id: 1, operator_id: 2)["status"]).to eq("success")
    end
  end

  describe "#call_transcription_list" do
    it "POSTs /project/speech/call/transcription/list with project" do
      stub_request(:post, "#{base_url}/project/speech/call/transcription/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.speech.call_transcription_list["status"]).to eq("success")
    end
  end

  describe "#dictionary_list" do
    it "POSTs /project/speech/dictionary/list with project" do
      stub_request(:post, "#{base_url}/project/speech/dictionary/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.speech.dictionary_list["status"]).to eq("success")
    end
  end

  describe "#dictionary_custom_create" do
    it "POSTs /project/speech/dictionary/custom/create with body" do
      stub_request(:post, "#{base_url}/project/speech/dictionary/custom/create")
        .with(query: {"project" => project}, body: {"name" => "Custom"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.dictionary_custom_create(name: "Custom")["status"]).to eq("success")
    end
  end

  describe "#dictionary_custom_update" do
    it "POSTs /project/speech/dictionary/custom/update with body" do
      stub_request(:post, "#{base_url}/project/speech/dictionary/custom/update")
        .with(query: {"project" => project}, body: {"id" => 1, "name" => "Renamed"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.dictionary_custom_update(id: 1, name: "Renamed")["status"]).to eq("success")
    end
  end

  describe "#dictionary_custom_delete" do
    it "POSTs /project/speech/dictionary/custom/delete with body" do
      stub_request(:post, "#{base_url}/project/speech/dictionary/custom/delete")
        .with(query: {"project" => project}, body: {"id" => 3}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.dictionary_custom_delete(id: 3)["status"]).to eq("success")
    end
  end

  describe "#dictionary_custom_phrase_list" do
    it "POSTs /project/speech/dictionary/custom/phrase/list with project" do
      stub_request(:post, "#{base_url}/project/speech/dictionary/custom/phrase/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.speech.dictionary_custom_phrase_list["status"]).to eq("success")
    end
  end

  describe "#settings_list" do
    it "POSTs /project/speech/settings/list with project" do
      stub_request(:post, "#{base_url}/project/speech/settings/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => {}}.to_json)

      expect(client.speech.settings_list["status"]).to eq("success")
    end
  end

  describe "#settings_update" do
    it "POSTs /project/speech/settings/update with body" do
      stub_request(:post, "#{base_url}/project/speech/settings/update")
        .with(query: {"project" => project}, body: {"enabled" => 1}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.speech.settings_update(enabled: 1)["status"]).to eq("success")
    end
  end
end
