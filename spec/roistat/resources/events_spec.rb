# frozen_string_literal: true

RSpec.describe Roistat::Resources::Events do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "events resource" do
    it "#send_event POSTs /project/events/send" do
      stub_request(:post, "#{base_url}/project/events/send")
        .with(
          query: {"project" => project},
          body: {"name" => "Purchase", "visit" => "100001"}.to_json
        )
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.events.send_event(name: "Purchase", visit: "100001")["status"]).to eq("success")
    end

    it "#bulk_send POSTs /project/events/bulk/send with array body" do
      events = [{"name" => "Open", "visit" => "1"}, {"name" => "Close", "visit" => "2"}]
      stub_request(:post, "#{base_url}/project/events/bulk/send")
        .with(query: {"project" => project}, body: events.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.events.bulk_send(events)["status"]).to eq("success")
    end

    it "#add POSTs /project/events/add with array body" do
      events = [{"display_name" => "test1", "type" => "js", "parameter" => "js-12"}]
      stub_request(:post, "#{base_url}/project/events/add")
        .with(query: {"project" => project}, body: events.to_json)
        .to_return(status: 200, body: {"events" => [{"id" => "13"}], "status" => "success"}.to_json)

      expect(client.events.add(events)["events"].first["id"]).to eq("13")
    end

    it "#log GETs /project/events/log with filter params" do
      stub_request(:get, "#{base_url}/project/events/log")
        .with(
          query: {
            "project" => project,
            "name" => "Cart",
            "date_from" => "2022-04-04T20:59:59.999Z"
          }
        )
        .to_return(status: 200, body: {"items" => [], "status" => "success"}.to_json)

      expect(
        client.events.log(name: "Cart", date_from: "2022-04-04T20:59:59.999Z")["status"]
      ).to eq("success")
    end

    it "#archive POSTs /project/events/meta/{id}/archive" do
      events = [{"display_name" => "test1", "type" => "js", "parameter" => "js-12"}]
      stub_request(:post, "#{base_url}/project/events/meta/9/archive")
        .with(query: {"project" => project}, body: events.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.events.archive(event_id: 9, events: events)["status"]).to eq("success")
    end
  end
end
