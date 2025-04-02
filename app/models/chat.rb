class Chat < ApplicationRecord
  include ActionView::RecordIdentifier
  acts_as_chat
  belongs_to :user

  # broadcasts_to ->(chat) { "chat_#{chat.id}" }

  after_update_commit { broadcast_updates! }

  def broadcast_updates!
    last_message = self.messages.last
    role = last_message.role
    sleep 5
    if role == "user"
      broadcast_append_to self, target: "messages", partial: "messages/message", locals: { message: last_message }
      broadcast_append_to self, target: "messages", partial: "messages/typing"
    elsif role == "assistant"
      broadcast_remove_to self, target: "typing"
      broadcast_append_to self, target: "messages", partial: "messages/message", locals: { message: last_message }
    end
  end

  def last_message
    message = self.messages.last
    message
  end

  # def summarize
  #   self.ask "Please summarize the our conversation so far."
  # end
  # def token_count
  #   messages.sum { |m| (m.imput_tokens || 0) + (m.output_tokens || 0) }
  # end
end
