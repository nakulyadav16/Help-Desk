class TicketReminderJob < ApplicationJob
  queue_as :default

  def perform
    Ticket.all.each do |ticket|
      if ticket.status == "open" && ticket.updated_at < 2.days.ago
        TicketGenerationMailer.ticket_reminder(ticket).deliver_now
      end
    end
  end
end
