# frozen_string_literal: true

class Roistat::Resources::Analytics < Roistat::Resources::Base
  # POST /project/analytics/data
  def data(**body)
    post_optional_body("project/analytics/data", body)
  end

  # POST /project/analytics/data/export/excel
  def data_export_excel(**body)
    client.post("project/analytics/data/export/excel", body: body, parse: :binary)
  end

  # POST /project/analytics/metrics-new
  def metrics_new(**body)
    post_optional_body("project/analytics/metrics-new", body)
  end

  # POST /project/analytics/dimensions
  def dimensions(**body)
    post_optional_body("project/analytics/dimensions", body)
  end

  # POST /project/analytics/dimension-values
  def dimension_values(**body)
    post_optional_body("project/analytics/dimension-values", body)
  end

  # POST /project/analytics/attribution-models
  def attribution_models(**body)
    post_optional_body("project/analytics/attribution-models", body)
  end

  # POST /project/analytics/list-orders
  def list_orders(**body)
    post_optional_body("project/analytics/list-orders", body)
  end

  # GET /project/analytics/metrics/custom/list
  def custom_metrics_list(**params)
    client.get("project/analytics/metrics/custom/list", params: params)
  end

  # POST /project/analytics/metrics/custom/manual/value/list
  def custom_manual_value_list(**body)
    post_optional_body("project/analytics/metrics/custom/manual/value/list", body)
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
    post_optional_body("project/reports/funnel/data", body)
  end

  # POST /project/analytics/event/add
  def event_add(**body)
    client.post("project/analytics/event/add", body: body)
  end
end
