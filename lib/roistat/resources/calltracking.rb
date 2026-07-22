# frozen_string_literal: true

class Roistat::Resources::Calltracking < Roistat::Resources::Base
  # POST /project/calltracking/script/list
  def script_list(**body)
    post("project/calltracking/script/list", body: body)
  end

  # POST /project/calltracking/script/create
  def script_create(**body)
    client.post("project/calltracking/script/create", body: body)
  end

  # POST /project/calltracking/script/update
  def script_update(**body)
    client.post("project/calltracking/script/update", body: body)
  end

  # POST /project/calltracking/script/delete
  def script_delete(id:)
    client.post("project/calltracking/script/delete", body: {id: id})
  end

  # POST /project/calltracking/phone/list
  def phone_list(**body)
    post("project/calltracking/phone/list", body: body)
  end

  # POST /project/calltracking/phone/prefix/list
  def phone_prefix_list(**body)
    post("project/calltracking/phone/prefix/list", body: body)
  end

  # POST /project/calltracking/phone/create
  def phone_create(phones:)
    client.post("project/calltracking/phone/create", body: {phones: phones})
  end

  # POST /project/calltracking/phone/buy
  def phone_buy(prefix:, count:)
    client.post("project/calltracking/phone/buy", body: {prefix: prefix, count: count})
  end

  # POST /project/calltracking/phone/update
  def phone_update(**body)
    client.post("project/calltracking/phone/update", body: body)
  end

  # POST /project/calltracking/phone/delete
  def phone_delete(phones:)
    client.post("project/calltracking/phone/delete", body: {phones: phones})
  end

  # POST /project/calltracking/call/list
  def call_list(**body)
    post("project/calltracking/call/list", body: body)
  end

  # POST /project/calltracking/call/update
  def call_update(**body)
    client.post("project/calltracking/call/update", body: body)
  end

  # POST /project/calltracking/call/delete
  def call_delete(ids:)
    client.post("project/calltracking/call/delete", body: {ids: ids})
  end

  # POST /project/calltracking/call/{callId}/file
  def call_file(call_id:)
    client.post("project/calltracking/call/#{call_id}/file", parse: :binary)
  end

  # POST /project/calltracking/call/xls/export
  def call_xls_export(period:)
    client.post(
      "project/calltracking/call/xls/export",
      body: {period: period},
      parse: :binary
    )
  end

  # POST /project/calltracking/data
  def data(period:)
    client.post("project/calltracking/data", body: {period: period})
  end

  # POST /project/phone-call
  def phone_call(**body)
    client.post("project/phone-call", body: body)
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
