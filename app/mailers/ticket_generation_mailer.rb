class TicketGenerationMailer < ApplicationMailer

  def ticket_generation(ticket)
    @ticket = ticket
    attachments['image.jpg'] = File.read('app/assets/images/ticket.jpg')
    mail(from: ticket.creator.email, to: ticket.assigned_to.email, subject: 'Ticket is raised to you')
  end

  def ticket_acceptance(ticket)
    @ticket = ticket
    mail(form: 'helpdesk@t.com', to: ticket.creator.email, subject: 'Your Ticket has been accepted')
  end

  def ticket_reminder(ticket)
    @ticket = ticket
    mail(from: "helpDesk@t.com" ,to: ticket.assigned_to.email , subject: "Remainder for ticket")
  end
  
end
