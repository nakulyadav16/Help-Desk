class MessagesController < ApplicationController

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @message = @ticket.messages.create(message_params)
    redirect_to ticket_path(@ticket)
  end

  private

  def message_params
    params.require(:message).permit(:content ,:user_id ,:ticket_id)
  end

end
