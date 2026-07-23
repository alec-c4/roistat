# frozen_string_literal: true

class Roistat::Resources::Emailtracking < Roistat::Resources::Base
  # POST /project/emailtracking/email/list
  def list(**body)
    client.post("project/emailtracking/email/list", body: body)
  end

  # GET /project/emailtracking/email/{email_id}/attachment/{attachment_id}
  def attachment(email_id:, attachment_id:)
    client.get(
      "project/emailtracking/email/#{escape_path_segment(email_id)}/attachment/" \
      "#{escape_path_segment(attachment_id)}",
      parse: :binary
    )
  end
end
