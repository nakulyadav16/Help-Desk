class MessagesController < ApplicationController
  def create
    @ticket = Ticket.find_by_slug(params[:ticket_slug])
    @message = @ticket.messages.new(message_params)
    @user_name = @message.user.name
    if @message.save
      if @message.documents.attached?
        @documents = []
        @message.documents.each do |document|
          @documents.append([rails_blob_url(document, disposition: 'inline'), document.filename])
        end
      end
      puts '-----------------'
      puts @documents
      ActionCable.server.broadcast "ticket_channel_#{@message.ticket_id}", { message: @message, documents: @documents, user_name: @user_name }
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, documents: []).merge(user_id: current_user.id )
  end
end
