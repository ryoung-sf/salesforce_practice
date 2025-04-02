FactoryBot.define do
  factory :chat do
    model_id  { "claude-3-5-sonnet-20241022" }
    user
  end
end