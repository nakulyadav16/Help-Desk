class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    html = ApplicationController.render( partial: 'messages/message',locals: {message: message} )
    
    ActionCable.server.broadcast "ticket_channel_#{message.ticket_id}" ,{ html: html}
  end
end
