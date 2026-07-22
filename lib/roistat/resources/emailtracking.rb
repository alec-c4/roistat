# frozen_string_literal: true

class Roistat::Resources::Emailtracking < Roistat::Resources::Base
  # POST /project/emailtracking/email/list
  def list(**body)
    post_optional_body("project/emailtracking/email/list", body)
  end

  # GET /project/emailtracking/email/{email_id}/attachment/{attachment_id}
  def attachment(email_id:, attachment_id:)
    client.get(
      "project/emailtracking/email/#{email_id}/attachment/#{attachment_id}",
      parse: :binary
    )
  end
end
