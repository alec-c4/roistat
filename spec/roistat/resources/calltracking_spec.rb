# frozen_string_literal: true

RSpec.describe Roistat::Resources::Calltracking do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }
  let(:period) { {from: "2022-07-01T00:00:00+0300", to: "2022-10-31T23:59:59+0300"} }

  describe "calltracking resource" do
    describe "#script_list" do
      it "POSTs /project/calltracking/script/list with project" do
        stub_request(:post, "#{base_url}/project/calltracking/script/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(status: 200, body: {"data" => [{"id" => 1}], "status" => "success"}.to_json)

        response = client.calltracking.script_list

        expect(response["status"]).to eq("success")
        expect(response["data"].first["id"]).to eq(1)
      end

      it "POSTs optional body when filters are given" do
        stub_request(:post, "#{base_url}/project/calltracking/script/list")
          .with(
            query: {"project" => project},
            headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
            body: {"is_deleted" => 0}.to_json
          )
          .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

        response = client.calltracking.script_list(is_deleted: 0)

        expect(response["status"]).to eq("success")
      end
    end

    describe "#script_create" do
      it "POSTs /project/calltracking/script/create with body" do
        body = {
          name: "Base",
          is_enabled: 1,
          creation_date: "2016-10-11T21:00:00.000Z",
          options: {
            css_selector: ["test"],
            redirect: {type: "phone", value: "74951234567"},
            replaceable_numbers: ["89451111111"]
          }
        }

        stub_request(:post, "#{base_url}/project/calltracking/script/create")
          .with(
            query: {"project" => project},
            headers: {"Api-key" => api_key, "Content-Type" => "application/json"},
            body: {
              "name" => "Base",
              "is_enabled" => 1,
              "creation_date" => "2016-10-11T21:00:00.000Z",
              "options" => {
                "css_selector" => ["test"],
                "redirect" => {"type" => "phone", "value" => "74951234567"},
                "replaceable_numbers" => ["89451111111"]
              }
            }.to_json
          )
          .to_return(status: 200, body: {"status" => "success", "data" => {"id" => 1}}.to_json)

        response = client.calltracking.script_create(**body)

        expect(response["data"]["id"]).to eq(1)
      end
    end

    describe "#script_update" do
      it "POSTs /project/calltracking/script/update with body" do
        stub_request(:post, "#{base_url}/project/calltracking/script/update")
          .with(
            query: {"project" => project},
            body: {"id" => 1, "name" => "New"}.to_json
          )
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        expect(client.calltracking.script_update(id: 1, name: "New")["status"]).to eq("success")
      end
    end

    describe "#script_delete" do
      it "POSTs /project/calltracking/script/delete with id" do
        stub_request(:post, "#{base_url}/project/calltracking/script/delete")
          .with(query: {"project" => project}, body: {"id" => 1}.to_json)
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        expect(client.calltracking.script_delete(id: 1)["status"]).to eq("success")
      end
    end

    describe "#phone_list" do
      it "POSTs /project/calltracking/phone/list with project" do
        stub_request(:post, "#{base_url}/project/calltracking/phone/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: {"data" => [{"id" => 5, "phone" => "74991234567"}], "status" => "success"}.to_json
          )

        response = client.calltracking.phone_list

        expect(response["data"].first["phone"]).to eq("74991234567")
      end
    end

    describe "#phone_prefix_list" do
      it "POSTs /project/calltracking/phone/prefix/list with project" do
        stub_request(:post, "#{base_url}/project/calltracking/phone/prefix/list")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: {"data" => [{"system_name" => "7499"}], "status" => "success"}.to_json
          )

        expect(client.calltracking.phone_prefix_list["data"].first["system_name"]).to eq("7499")
      end
    end

    describe "#phone_create" do
      it "POSTs /project/calltracking/phone/create with phones" do
        stub_request(:post, "#{base_url}/project/calltracking/phone/create")
          .with(query: {"project" => project}, body: {"phones" => ["74997654321"]}.to_json)
          .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

        expect(client.calltracking.phone_create(phones: ["74997654321"])["status"]).to eq("success")
      end
    end

    describe "#phone_buy" do
      it "POSTs /project/calltracking/phone/buy with prefix and count" do
        stub_request(:post, "#{base_url}/project/calltracking/phone/buy")
          .with(query: {"project" => project}, body: {"prefix" => "7499", "count" => 1}.to_json)
          .to_return(status: 200, body: {"status" => "success", "data" => []}.to_json)

        expect(client.calltracking.phone_buy(prefix: "7499", count: 1)["status"]).to eq("success")
      end
    end

    describe "#phone_update" do
      it "POSTs /project/calltracking/phone/update with body" do
        stub_request(:post, "#{base_url}/project/calltracking/phone/update")
          .with(query: {"project" => project}, body: {"id" => 6, "script_id" => 11}.to_json)
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        expect(client.calltracking.phone_update(id: 6, script_id: 11)["status"]).to eq("success")
      end
    end

    describe "#phone_delete" do
      it "POSTs /project/calltracking/phone/delete with phone ids" do
        stub_request(:post, "#{base_url}/project/calltracking/phone/delete")
          .with(query: {"project" => project}, body: {"phones" => [4, 5]}.to_json)
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        expect(client.calltracking.phone_delete(phones: [4, 5])["status"]).to eq("success")
      end
    end

    describe "#call_list" do
      it "POSTs /project/calltracking/call/list with filters" do
        filters = {and: [["date", ">", "2022-05-21T21:00:00+0000"]]}

        stub_request(:post, "#{base_url}/project/calltracking/call/list")
          .with(
            query: {"project" => project},
            body: {
              "filters" => {"and" => [["date", ">", "2022-05-21T21:00:00+0000"]]},
              "limit" => 10
            }.to_json
          )
          .to_return(status: 200, body: {"data" => [{"id" => "1"}], "status" => "success"}.to_json)

        response = client.calltracking.call_list(filters: filters, limit: 10)

        expect(response["data"].first["id"]).to eq("1")
      end
    end

    describe "#call_update" do
      it "POSTs /project/calltracking/call/update with body" do
        stub_request(:post, "#{base_url}/project/calltracking/call/update")
          .with(query: {"project" => project}, body: {"id" => 123, "comment" => "note"}.to_json)
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        expect(client.calltracking.call_update(id: 123, comment: "note")["status"]).to eq("success")
      end
    end

    describe "#call_delete" do
      it "POSTs /project/calltracking/call/delete with ids" do
        stub_request(:post, "#{base_url}/project/calltracking/call/delete")
          .with(query: {"project" => project}, body: {"ids" => [1, 2]}.to_json)
          .to_return(status: 200, body: {"status" => "success"}.to_json)

        expect(client.calltracking.call_delete(ids: [1, 2])["status"]).to eq("success")
      end
    end

    describe "#call_file" do
      it "POSTs /project/calltracking/call/{id}/file and returns binary" do
        audio = "ID3fake-mp3".b
        stub_request(:post, "#{base_url}/project/calltracking/call/1234/file")
          .with(query: {"project" => project}, headers: {"Api-key" => api_key})
          .to_return(
            status: 200,
            body: audio,
            headers: {"Content-Type" => "audio/mpeg", "Content-Length" => audio.bytesize.to_s}
          )

        result = client.calltracking.call_file(call_id: 1234)

        expect(result.b).to eq(audio)
        expect(result).to be_a(String)
      end
    end

    describe "#call_xls_export" do
      it "POSTs /project/calltracking/call/xls/export and returns binary" do
        xls = "\xD0\xCF\x11\xE0fake-xls".b
        stub_request(:post, "#{base_url}/project/calltracking/call/xls/export")
          .with(
            query: {"project" => project},
            body: {"period" => {"from" => period[:from], "to" => period[:to]}}.to_json
          )
          .to_return(
            status: 200,
            body: xls,
            headers: {
              "Content-Type" => "application/vnd.ms-excel",
              "Content-Length" => xls.bytesize.to_s
            }
          )

        result = client.calltracking.call_xls_export(period: period)

        expect(result.b).to eq(xls)
      end
    end

    describe "#data" do
      it "POSTs /project/calltracking/data with period" do
        stub_request(:post, "#{base_url}/project/calltracking/data")
          .with(
            query: {"project" => project},
            body: {"period" => {"from" => period[:from], "to" => period[:to]}}.to_json
          )
          .to_return(status: 200, body: {"status" => "success", "data" => {}}.to_json)

        expect(client.calltracking.data(period: period)["status"]).to eq("success")
      end
    end

    describe "#phone_call" do
      it "POSTs /project/phone-call with call payload" do
        body = {
          name: "Scenario 1",
          callee: "79999999999",
          caller: "78888888888",
          date: "2016-07-26T11:03:57+0000"
        }

        stub_request(:post, "#{base_url}/project/phone-call")
          .with(
            query: {"project" => project},
            body: {
              "name" => "Scenario 1",
              "callee" => "79999999999",
              "caller" => "78888888888",
              "date" => "2016-07-26T11:03:57+0000"
            }.to_json
          )
          .to_return(status: 200, body: {"status" => "success", "phoneCall" => {"id" => "5"}}.to_json)

        response = client.calltracking.phone_call(**body)

        expect(response["phoneCall"]["id"]).to eq("5")
      end
    end
  end
end
