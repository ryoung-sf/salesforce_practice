FactoryBot.define do
  factory :message do
    role { "user" }
    content { "Write a short poem about ruby" }
    chat
    user
  end
end