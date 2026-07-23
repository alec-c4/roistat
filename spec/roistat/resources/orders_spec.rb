# frozen_string_literal: true

RSpec.describe Roistat::Resources::Orders do
  let(:api_key) { "test-api-key" }
  let(:project) { "12345" }
  let(:base_url) { "https://cloud.roistat.com/api/v1" }
  let(:client) { Roistat::Client.new(api_key: api_key, project: project) }

  describe "orders resource" do
    it "#list POSTs /project/integration/order/list" do
      stub_request(:post, "#{base_url}/project/integration/order/list")
        .with(query: {"project" => project}, body: {"limit" => 10}.to_json)
        .to_return(status: 200, body: {"data" => [{"id" => "1"}], "status" => "success"}.to_json)

      expect(client.orders.list(limit: 10)["data"].first["id"]).to eq("1")
    end

    it "#add POSTs /project/add-orders with array body" do
      orders = [{"id" => "1", "name" => "New order", "date_create" => "2022-06-19T00:32:12+0000"}]
      stub_request(:post, "#{base_url}/project/add-orders")
        .with(query: {"project" => project}, body: orders.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.add(orders)["status"]).to eq("success")
    end

    it "#info GETs /project/orders/{id}/info" do
      stub_request(:get, "#{base_url}/project/orders/order_1/info")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"order" => {"id" => "order_1"}, "status" => "success"}.to_json)

      expect(client.orders.info(order_id: "order_1")["order"]["id"]).to eq("order_1")
    end

    it "#info escapes special characters in order_id so they can't alter the request path" do
      stub_request(:get, "#{base_url}/project/orders/a%2Fb%20c/info")
        .with(query: {"project" => project})
        .to_return(status: 200, body: {"order" => {"id" => "a/b c"}, "status" => "success"}.to_json)

      expect(client.orders.info(order_id: "a/b c")["order"]["id"]).to eq("a/b c")
    end

    it "#external_url GETs /project/orders/{id}/external-url" do
      stub_request(:get, "#{base_url}/project/orders/order_1/external-url")
        .with(query: {"project" => project})
        .to_return(status: 200, body: {"externalUrl" => "https://crm.example/1", "status" => "success"}.to_json)

      expect(client.orders.external_url(order_id: "order_1")["externalUrl"]).to include("crm.example")
    end

    it "#status_list POSTs /project/integration/status/list" do
      stub_request(:post, "#{base_url}/project/integration/status/list")
        .with(query: {"project" => project}, headers: {"Api-key" => api_key})
        .to_return(status: 200, body: {"data" => [{"id" => "1"}], "status" => "success"}.to_json)

      expect(client.orders.status_list["data"].first["id"]).to eq("1")
    end

    it "#set_statuses POSTs /project/set-statuses with array body" do
      statuses = [{"id" => "1", "name" => "New", "type" => "progress"}]
      stub_request(:post, "#{base_url}/project/set-statuses")
        .with(query: {"project" => project}, body: statuses.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.set_statuses(statuses)["status"]).to eq("success")
    end

    it "#custom_fields POSTs /project/analytics/order-custom-fields" do
      stub_request(:post, "#{base_url}/project/analytics/order-custom-fields")
        .with(query: {"project" => project})
        .to_return(status: 200, body: {"fields" => ["Manager"], "status" => "success"}.to_json)

      expect(client.orders.custom_fields["fields"]).to eq(["Manager"])
    end

    it "#status_update POSTs status update path" do
      stub_request(:post, "#{base_url}/project/integration/order/123/status/update")
        .with(query: {"project" => project}, body: {"status_id" => "1"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.status_update(order_id: "123", status_id: "1")["status"]).to eq("success")
    end

    it "#goal_update POSTs goal update path" do
      stub_request(:post, "#{base_url}/project/integration/order/123/goal/update")
        .with(query: {"project" => project}, body: {"title" => "Lead"}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.goal_update(order_id: "123", title: "Lead")["status"]).to eq("success")
    end

    it "#update POSTs /project/integration/order/update" do
      stub_request(:post, "#{base_url}/project/integration/order/update")
        .with(query: {"project" => project}, body: {"orders" => [{"id" => "1", "status" => "1"}]}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.update(orders: [{id: "1", status: "1"}])["status"]).to eq("success")
    end

    it "#delete POSTs /project/integration/order/{id}/delete" do
      stub_request(:post, "#{base_url}/project/integration/order/order_1/delete")
        .with(query: {"project" => project})
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.delete(order_id: "order_1")["status"]).to eq("success")
    end

    it "#delete_many POSTs /project/integration/order/delete" do
      stub_request(:post, "#{base_url}/project/integration/order/delete")
        .with(query: {"project" => project}, body: {"ids" => ["a", "b"]}.to_json)
        .to_return(status: 200, body: {"status" => "success"}.to_json)

      expect(client.orders.delete_many(ids: %w[a b])["status"]).to eq("success")
    end
  end
end
