# frozen_string_literal: true

class Roistat::Resources::Analytics < Roistat::Resources::Base
  # POST /project/analytics/data
  def data(**body)
    client.post("project/analytics/data", body: body)
  end

  # POST /project/analytics/data/export/excel
  def data_export_excel(**body)
    client.post("project/analytics/data/export/excel", body: body, parse: :binary)
  end

  # POST /project/analytics/metrics-new
  def metrics_new(**body)
    client.post("project/analytics/metrics-new", body: body)
  end

  # POST /project/analytics/dimensions
  def dimensions(**body)
    client.post("project/analytics/dimensions", body: body)
  end

  # POST /project/analytics/dimension-values
  def dimension_values(**body)
    client.post("project/analytics/dimension-values", body: body)
  end

  # POST /project/analytics/attribution-models
  def attribution_models(**body)
    client.post("project/analytics/attribution-models", body: body)
  end

  # POST /project/analytics/list-orders
  def list_orders(**body)
    client.post("project/analytics/list-orders", body: body)
  end

  # GET /project/analytics/metrics/custom/list
  def custom_metrics_list(**params)
    client.get("project/analytics/metrics/custom/list", params: params)
  end

  # POST /project/analytics/metrics/custom/manual/value/list
  def custom_manual_value_list(**body)
    client.post("project/analytics/metrics/custom/manual/value/list", body: body)
  end

  # POST /project/analytics/metrics/custom/manual/value/add
  def custom_manual_value_add(**body)
    client.post("project/analytics/metrics/custom/manual/value/add", body: body)
  end

  # POST /project/analytics/metrics/custom/manual/value/delete
  def custom_manual_value_delete(**body)
    client.post("project/analytics/metrics/custom/manual/value/delete", body: body)
  end

  # POST /project/reports/funnel/data
  def funnel_data(**body)
    client.post("project/reports/funnel/data", body: body)
  end

  # POST /project/analytics/event/add
  def event_add(**body)
    client.post("project/analytics/event/add", body: body)
  end
end
