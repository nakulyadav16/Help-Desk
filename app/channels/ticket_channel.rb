class TicketChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ticket_channel_#{params[:ticket_id]}"
  end

  def unsubscribed
  end
end
