# frozen_string_literal: true

class Roistat::Resources::Sms < Roistat::Resources::Base
  # POST /project/set-sms-report-enabled
  def set_report_enabled(enabled:)
    flag =
      case enabled
      when true, "1", 1 then "1"
      when false, "0", 0 then "0"
      else enabled.to_s
      end

    client.post("project/set-sms-report-enabled", body: {enabled: flag})
  end
end
