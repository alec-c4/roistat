# frozen_string_literal: true

class Roistat::Resources::Billing < Roistat::Resources::Base
  # POST /user/billing/transactions/list
  def transactions_list(period:)
    client.post("user/billing/transactions/list", body: {period: period})
  end

  # POST /user/billing/transactions/list/export/excel
  def transactions_export_excel(period:)
    client.post(
      "user/billing/transactions/list/export/excel",
      body: {period: period},
      parse: :binary
    )
  end
end
