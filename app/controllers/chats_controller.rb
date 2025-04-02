class ChatsController < ApplicationController
  def index
    @chats = current_user.chats
  end

  def new
    @chat = current_user.chats.new
    @anthropic_models = RubyLLM.models.by_provider("anthropic").chat_models.collect(&:id)
  end

  def show
    @chat = Chat.find(params[:id])
  end

  def ask
    @chat = Chat.find(params[:id])
    # message = params[:message]

    # Turbo::StreamsChannel.broadcast_append_to(
    #   @chat,
    #   target: "messages",
    #   partial: "messages/typing",
    #   )
    # binding.b
    # Turbo::StreamsChannel.broadcast_append_to @chat, target: "messages", partial: "messages/typing"
    chunks = ""
    @chat.ask(params[:message]) do |chunk|
      chunks += chunk.content unless chunk.content.nil?
      Turbo::StreamsChannel.broadcast_append_to(
        @chat,
        target: "assistant_message_#{@chat.messages.last.id}",
        partial: "messages/assistant",
        locals: { message: @chat.messages.last, chunks: },
      )
    end
    # Turbo::StreamsChannel.broadcast_remove_to @chat, target: "messages", partial: "messages/typing"
    # ChatJob.perform_later(@chat.id, params[:message])
    # Turbo::StreamsChannel.broadcast_append_to(
    #   @chat,
    #   target: "messages",
    #   partial: "messages/message",
    #   locals: { message: @chat.messages.last },
    # )
    # chat.ask(message) do |chunk|
    # if chunk == chat.messages.last.to_llm.content[0...chunk.content.length]



    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  def create
      @chat = Chat.new(model_id: params[:chat][:model_id], user: current_user)
      if @chat.save
        redirect_to chat_path(@chat)
      else
        render :new
      end
  end

  # def ask
  #   @chat = Chat.find(params[:id])

  #   Chatjob.perform_later(@chat.id, params[:message])

  #   respond_to do |format|
  #     format.turbo_stream
  #     format.html { redirect_to chat_path(@chat) }
  #   end
  # end
end
