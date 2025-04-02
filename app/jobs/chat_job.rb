class ChatJob < ApplicationJob
  queue_as :default

  def perform(chat_id, message)
    binding.b
    chat = Chat.find(chat_id)

    # Start with  a "typing" indicator
    Turbo::StreamsChannel.broadcast_append_to(
      chat,
      target: "messages",
      partial: "messages/typing",
    )

    chat.ask(message) do |chunk|
      # removing typing indicator after first chunk
      if chunk == chat.messages.last.to_llm.content[0...chunk.content.length]
        Turbo::StreamsChannel.broadcast_remove_to(
          chat,
          target: "typing"
        )
      end

      # Update the streaming messages
      Turbo::StreamsChannel.broadcast_replace_to(
        chat,
        target: "assistant_message_#{chat.messages.last.id}",
        partial: "messages/message",
        locals: { message: chat.messages.last, content: chunk.content }
      )
    end
  end
end
