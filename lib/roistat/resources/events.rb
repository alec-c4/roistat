# frozen_string_literal: true

class Roistat::Resources::Events < Roistat::Resources::Base
  # POST /project/events/send
  def send_event(**body)
    client.post("project/events/send", body: body)
  end

  # POST /project/events/bulk/send — body is a JSON array
  def bulk_send(events)
    client.post("project/events/bulk/send", body: events)
  end

  # POST /project/events/add — body is a JSON array
  def add(events)
    client.post("project/events/add", body: events)
  end

  # GET /project/events/log — filters as query params (docs heading; curl shows POST JSON)
  def log(**params)
    if params.nil? || params.empty?
      client.get("project/events/log")
    else
      client.get("project/events/log", params: params)
    end
  end

  # POST /project/events/meta/{eventId}/archive — body is a JSON array
  def archive(event_id:, events:)
    client.post("project/events/meta/#{escape_path_segment(event_id)}/archive", body: events)
  end
end
