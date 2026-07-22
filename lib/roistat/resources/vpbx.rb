# frozen_string_literal: true

class Roistat::Resources::Vpbx < Roistat::Resources::Base
  # POST /project/vpbx/call/list
  def call_list(**body)
    post_optional_body("project/vpbx/call/list", body)
  end

  # POST /project/vpbx/operator/list
  def operator_list(**body)
    post_optional_body("project/vpbx/operator/list", body)
  end

  # POST /project/vpbx/operator/create
  def operator_create(**body)
    client.post("project/vpbx/operator/create", body: body)
  end

  # POST /project/vpbx/operator/update
  def operator_update(**body)
    client.post("project/vpbx/operator/update", body: body)
  end

  # POST /project/vpbx/operator/deactivate
  def operator_deactivate(**body)
    client.post("project/vpbx/operator/deactivate", body: body)
  end

  # POST /project/vpbx/operator/group/list
  def operator_group_list(**body)
    post_optional_body("project/vpbx/operator/group/list", body)
  end

  # POST /project/vpbx/operator/group/create
  def operator_group_create(**body)
    client.post("project/vpbx/operator/group/create", body: body)
  end

  # POST /project/vpbx/operator/group/update
  def operator_group_update(**body)
    client.post("project/vpbx/operator/group/update", body: body)
  end

  # GET /project/vpbx/phone/list
  def phone_list(**params)
    client.get("project/vpbx/phone/list", params: params)
  end

  # POST /project/vpbx/phone/create
  def phone_create(**body)
    client.post("project/vpbx/phone/create", body: body)
  end

  # POST /project/vpbx/phone/update
  def phone_update(**body)
    client.post("project/vpbx/phone/update", body: body)
  end

  # POST /project/vpbx/phone/delete
  def phone_delete(**body)
    client.post("project/vpbx/phone/delete", body: body)
  end

  # GET /project/vpbx/script/list
  def script_list(**params)
    client.get("project/vpbx/script/list", params: params)
  end

  # POST /project/vpbx/script/create
  def script_create(**body)
    client.post("project/vpbx/script/create", body: body)
  end

  # POST /project/vpbx/script/update
  def script_update(**body)
    client.post("project/vpbx/script/update", body: body)
  end

  # POST /project/vpbx/script/delete
  def script_delete(**body)
    client.post("project/vpbx/script/delete", body: body)
  end

  # POST /project/vpbx/report/data
  def report_data(**body)
    post_optional_body("project/vpbx/report/data", body)
  end

  # POST /project/vpbx/settings/update
  def settings_update(**body)
    client.post("project/vpbx/settings/update", body: body)
  end

  # POST /project/vpbx/settings/file/audio/upload (multipart/form-data)
  def settings_file_audio_upload(file:, **fields)
    form = fields.transform_keys(&:to_s)
    form["file"] = file
    client.post_multipart("project/vpbx/settings/file/audio/upload", form: form)
  end
end
