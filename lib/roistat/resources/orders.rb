# frozen_string_literal: true

class Roistat::Resources::Orders < Roistat::Resources::Base
  # POST /project/integration/order/list
  def list(**body)
    post("project/integration/order/list", body: body)
  end

  # POST /project/add-orders — body is a JSON array
  def add(orders)
    client.post("project/add-orders", body: orders)
  end

  # GET /project/orders/{orderId}/info
  def info(order_id:)
    client.get("project/orders/#{order_id}/info")
  end

  # GET /project/orders/{orderId}/external-url
  def external_url(order_id:)
    client.get("project/orders/#{order_id}/external-url")
  end

  # POST /project/integration/status/list
  def status_list(**body)
    post("project/integration/status/list", body: body)
  end

  # POST /project/set-statuses — body is a JSON array
  def set_statuses(statuses)
    client.post("project/set-statuses", body: statuses)
  end

  # POST /project/analytics/order-custom-fields
  def custom_fields(**body)
    post("project/analytics/order-custom-fields", body: body)
  end

  # POST /project/integration/order/{orderId}/status/update
  def status_update(order_id:, status_id:)
    client.post(
      "project/integration/order/#{order_id}/status/update",
      body: {status_id: status_id}
    )
  end

  # POST /project/integration/order/{orderId}/goal/update
  def goal_update(order_id:, **body)
    client.post("project/integration/order/#{order_id}/goal/update", body: body)
  end

  # POST /project/integration/order/update
  def update(orders:)
    client.post("project/integration/order/update", body: {orders: orders})
  end

  # POST /project/integration/order/{orderId}/delete
  def delete(order_id:)
    client.post("project/integration/order/#{order_id}/delete")
  end

  # POST /project/integration/order/delete
  def delete_many(ids:)
    client.post("project/integration/order/delete", body: {ids: ids})
  end

  private

  def post(path, body:)
    if body.nil? || body.empty?
      client.post(path)
    else
      client.post(path, body: body)
    end
  end
end
