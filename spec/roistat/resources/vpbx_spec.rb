# frozen_string_literal: true

RSpec.describe Roistat::Resources::Vpbx do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "#call_list" do
    it "POSTs /project/vpbx/call/list with project" do
      stub_request(:post, "#{base_url}/project/vpbx/call/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.vpbx.call_list["status"]).to eq("success")
    end
  end

  describe "#operator_list" do
    it "POSTs /project/vpbx/operator/list with project" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.vpbx.operator_list["status"]).to eq("success")
    end
  end

  describe "#operator_create" do
    it "POSTs /project/vpbx/operator/create with body" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/create")
        .with(query: {"project" => project}, body: {"name" => "Ann"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.operator_create(name: "Ann")["status"]).to eq("success")
    end
  end

  describe "#operator_update" do
    it "POSTs /project/vpbx/operator/update with body" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/update")
        .with(query: {"project" => project}, body: {"id" => 1, "name" => "Bob"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.operator_update(id: 1, name: "Bob")["status"]).to eq("success")
    end
  end

  describe "#operator_deactivate" do
    it "POSTs /project/vpbx/operator/deactivate with body" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/deactivate")
        .with(query: {"project" => project}, body: {"id" => 2}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.operator_deactivate(id: 2)["status"]).to eq("success")
    end
  end

  describe "#operator_group_list" do
    it "POSTs /project/vpbx/operator/group/list with project" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/group/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.vpbx.operator_group_list["status"]).to eq("success")
    end
  end

  describe "#operator_group_create" do
    it "POSTs /project/vpbx/operator/group/create with body" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/group/create")
        .with(query: {"project" => project}, body: {"name" => "Sales"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.operator_group_create(name: "Sales")["status"]).to eq("success")
    end
  end

  describe "#operator_group_update" do
    it "POSTs /project/vpbx/operator/group/update with body" do
      stub_request(:post, "#{base_url}/project/vpbx/operator/group/update")
        .with(query: {"project" => project}, body: {"id" => 1, "name" => "Support"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.operator_group_update(id: 1, name: "Support")["status"]).to eq("success")
    end
  end

  describe "#phone_list" do
    it "GETs /project/vpbx/phone/list with project" do
      stub_request(:get, "#{base_url}/project/vpbx/phone/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.vpbx.phone_list["status"]).to eq("success")
    end
  end

  describe "#phone_create" do
    it "POSTs /project/vpbx/phone/create with body" do
      stub_request(:post, "#{base_url}/project/vpbx/phone/create")
        .with(query: {"project" => project}, body: {"number" => "74951234567"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.phone_create(number: "74951234567")["status"]).to eq("success")
    end
  end

  describe "#phone_update" do
    it "POSTs /project/vpbx/phone/update with body" do
      stub_request(:post, "#{base_url}/project/vpbx/phone/update")
        .with(query: {"project" => project}, body: {"id" => 1, "name" => "Main"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.phone_update(id: 1, name: "Main")["status"]).to eq("success")
    end
  end

  describe "#phone_delete" do
    it "POSTs /project/vpbx/phone/delete with body" do
      stub_request(:post, "#{base_url}/project/vpbx/phone/delete")
        .with(query: {"project" => project}, body: {"id" => 9}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.phone_delete(id: 9)["status"]).to eq("success")
    end
  end

  describe "#script_list" do
    it "GETs /project/vpbx/script/list with project" do
      stub_request(:get, "#{base_url}/project/vpbx/script/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

      expect(client.vpbx.script_list["status"]).to eq("success")
    end
  end

  describe "#script_create" do
    it "POSTs /project/vpbx/script/create with body" do
      stub_request(:post, "#{base_url}/project/vpbx/script/create")
        .with(query: {"project" => project}, body: {"name" => "IVR"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.script_create(name: "IVR")["status"]).to eq("success")
    end
  end

  describe "#script_update" do
    it "POSTs /project/vpbx/script/update with body" do
      stub_request(:post, "#{base_url}/project/vpbx/script/update")
        .with(query: {"project" => project}, body: {"id" => 1, "name" => "IVR2"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.script_update(id: 1, name: "IVR2")["status"]).to eq("success")
    end
  end

  describe "#script_delete" do
    it "POSTs /project/vpbx/script/delete with body" do
      stub_request(:post, "#{base_url}/project/vpbx/script/delete")
        .with(query: {"project" => project}, body: {"id" => 4}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.script_delete(id: 4)["status"]).to eq("success")
    end
  end

  describe "#report_data" do
    it "POSTs /project/vpbx/report/data with project" do
      stub_request(:post, "#{base_url}/project/vpbx/report/data")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => {}}.to_json)

      expect(client.vpbx.report_data["status"]).to eq("success")
    end
  end

  describe "#settings_update" do
    it "POSTs /project/vpbx/settings/update with body" do
      stub_request(:post, "#{base_url}/project/vpbx/settings/update")
        .with(query: {"project" => project}, body: {"timezone" => "Europe/Moscow"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.vpbx.settings_update(timezone: "Europe/Moscow")["status"]).to eq("success")
    end
  end

  describe "#settings_file_audio_upload" do
    it "POSTs multipart /project/vpbx/settings/file/audio/upload" do
      file = StringIO.new("WAVDATA")
      file.define_singleton_method(:path) { "hold.wav" }

      stub = stub_request(:post, "#{base_url}/project/vpbx/settings/file/audio/upload")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"status" => "success", "data" => {"id" => 1}}.to_json)

      expect(client.vpbx.settings_file_audio_upload(file: file)["status"]).to eq("success")
      expect(stub).to have_been_requested
    end
  end
end
