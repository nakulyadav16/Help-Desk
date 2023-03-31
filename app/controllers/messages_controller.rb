class MessagesController < ApplicationController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @message = @ticket.messages.new(message_params)
    if @message.save
      ActionCable.server.broadcast "ticket_channel_#{@message.ticket_id}", { data: @message }
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, documents: []).merge({ "user_id"=> current_user.id })
  end
end
