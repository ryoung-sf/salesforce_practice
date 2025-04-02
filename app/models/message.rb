class Message < ApplicationRecord
  acts_as_message

  after_create_commit { chat.broadcast_updates! }
end
