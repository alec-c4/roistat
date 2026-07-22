# frozen_string_literal: true

class Roistat::Resources::Widgets < Roistat::Resources::Base
  # GET|POST /project/widget/{widgetId}/data — help-en; curl usually POSTs.
  def data(widget_id:, method: :post, **body)
    path = "project/widget/#{widget_id}/data"

    case method.to_sym
    when :get
      client.get(path)
    when :post
      post_optional_body(path, body)
    else
      raise ArgumentError, "method must be :get or :post"
    end
  end
end
