# frozen_string_literal: true

class Roistat::Resources::Speech < Roistat::Resources::Base
  # POST /project/speech/call/list
  def call_list(**body)
    client.post("project/speech/call/list", body: body)
  end

  # POST /project/speech/call/list/export/excel
  def call_list_export_excel(**body)
    client.post("project/speech/call/list/export/excel", body: body, parse: :binary)
  end

  # POST /project/speech/call/add
  def call_add(**body)
    client.post("project/speech/call/add", body: body)
  end

  # POST /project/speech/call/comment/update
  def call_comment_update(**body)
    client.post("project/speech/call/comment/update", body: body)
  end

  # POST /project/speech/call/operator/update
  def call_operator_update(**body)
    client.post("project/speech/call/operator/update", body: body)
  end

  # POST /project/speech/call/transcription/list
  def call_transcription_list(**body)
    client.post("project/speech/call/transcription/list", body: body)
  end

  # POST /project/speech/dictionary/list
  def dictionary_list(**body)
    client.post("project/speech/dictionary/list", body: body)
  end

  # POST /project/speech/dictionary/custom/create
  def dictionary_custom_create(**body)
    client.post("project/speech/dictionary/custom/create", body: body)
  end

  # POST /project/speech/dictionary/custom/update
  def dictionary_custom_update(**body)
    client.post("project/speech/dictionary/custom/update", body: body)
  end

  # POST /project/speech/dictionary/custom/delete
  def dictionary_custom_delete(**body)
    client.post("project/speech/dictionary/custom/delete", body: body)
  end

  # POST /project/speech/dictionary/custom/phrase/list
  def dictionary_custom_phrase_list(**body)
    client.post("project/speech/dictionary/custom/phrase/list", body: body)
  end

  # POST /project/speech/settings/list
  def settings_list(**body)
    client.post("project/speech/settings/list", body: body)
  end

  # POST /project/speech/settings/update
  def settings_update(**body)
    client.post("project/speech/settings/update", body: body)
  end
end
