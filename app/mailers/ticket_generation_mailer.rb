class TicketGenerationMailer < ApplicationMailer

  def ticket_generation(assigned_to_user, current_user)
    @assigned_to_user  = assigned_to_user       
    mail(from: current_user.email ,to: @assigned_to_user.email , subject: "ticket is generated")
  end
  
end
