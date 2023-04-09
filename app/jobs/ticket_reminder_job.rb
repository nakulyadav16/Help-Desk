class TicketReminderJob < ApplicationJob
  queue_as :default

  def perform(ticket_id)
    ticket = Ticket.find(ticket_id)
    if ticket.status == "open" && ticket.created_at < 2.days.ago
      TicketGenerationMailer.ticket_reminder(ticket.assigned_to).deliver_later
    end
  end

end
