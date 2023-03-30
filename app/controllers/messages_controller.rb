class MessagesController < ApplicationController
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @message = @ticket.messages.create(message_params)
    ActionCable.server.broadcast "ticket_channel_#{@message.ticket_id}" ,{ data: @message }
  end

  private
  def message_params
    params.require(:message).permit(:content ,:user_id ,:ticket_id, documents: [])
  end
end
