class TicketGenerationMailer < ApplicationMailer

  def ticket_generation(assigned_to_user, current_user)
    @assigned_to_user = assigned_to_user
    mail(from: current_user.email, to: @assigned_to_user.email, subject: 'Ticket is raised to you')
  end

  def ticket_acceptance(ticket)
    @ticket = ticket
    mail(form: 'helpdesk@t.com', to: ticket.creator.email, subject: 'Your Ticket has been accepted')
  end
end
