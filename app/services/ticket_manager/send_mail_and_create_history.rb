module TicketManager
  class SendMailAndCreateHistory < ApplicationService
    def initialize(ticket)
      @ticket = ticket
    end

    def call
      send_mail_and_create_history
    end

    private

    attr_reader :ticket

    def send_mail_and_create_history 
      TicketGenerationMailer.ticket_generation(ticket).deliver_later
      TicketHistory.create(ticket_id: ticket.id, user_id: ticket.assigned_to_id)
    end
  end
end