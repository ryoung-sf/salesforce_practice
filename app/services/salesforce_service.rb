class SalesforceService
  def accounts
    client.query("select Id, Name from Account")
  end

  def opportunities
    client.query("select Id, Name from Opportunity")
  end

  def get_object_columns(object_name:)
    client.describe(object_name).fields.map(&:name)
  end

  def self.health
    new.client.query("select Name from User").count > 0
  rescue StandardError => e
    e.message
  end

  def client
    @client ||= Restforce.new(
      host: Rails.configuration.salesforce.host,
      client_id: Rails.configuration.salesforce.client_id,
      client_secret: Rails.configuration.salesforce.client_secret,
      api_version: Rails.configuration.salesforce.api_version,
    )
  end
end
