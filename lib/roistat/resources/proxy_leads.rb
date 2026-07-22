# frozen_string_literal: true

class Roistat::Resources::ProxyLeads < Roistat::Resources::Base
  # GET /project/proxy-leads?period=YYYY-MM-DD-YYYY-MM-DD
  def list(period:)
    client.get("project/proxy-leads", params: {period: period})
  end

  # GET /project/proxy-leads/duplicates?period=YYYY-MM-DD-YYYY-MM-DD
  def duplicates(period:)
    client.get("project/proxy-leads/duplicates", params: {period: period})
  end

  # GET /project/proxy-leads/{proxyLeadId}
  def get(id:)
    client.get("project/proxy-leads/#{id}")
  end
end
