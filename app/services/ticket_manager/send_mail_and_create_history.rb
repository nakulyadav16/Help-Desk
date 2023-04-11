module TicketManager
  class SendMailAndCreateHistory < ApplicationService
    def initialize(ticket, current_user)
      @ticket = ticket
      @current_user = current_user
    end

    def call
      send_mail_and_create_history
    end

    private

    attr_reader :ticket, :current_user

    def send_mail_and_create_history 
      TicketGenerationMailer.ticket_generation(ticket.assigned_to, current_user).deliver_later
      TicketHistory.create(ticket_id: ticket.id, user_id: ticket.assigned_to_id)
    end
  end
end