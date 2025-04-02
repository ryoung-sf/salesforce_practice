if !Rails.env.development?
  puts "[ db/seeds.rb ] Seed data is for development only, " +
        "not for #{Rails.env} environment."
  exit 0
end

require "factory_bot_rails"

User.destroy_all

puts "[ db/seeds.rb ] Creating users..."
FactoryBot.create(:user, email: "test_user@gmail.com", password: "password")
5.times do |i|
  FactoryBot.create(:user, email: "test_user_#{i}@gmail.com", password: "password_#{i}")
end

puts "[ db/seeds.rb ] Done!"
