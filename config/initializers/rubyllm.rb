RubyLLM.configure do |config|
  config.anthropic_api_key = Rails.application.credentials.anthropic_api_key
  config.openai_api_key = Rails.application.credentials.openai_api_key
end