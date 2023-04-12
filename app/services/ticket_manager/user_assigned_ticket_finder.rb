module TicketManager
  class UserAssignedTicketFinder < ApplicationService
    def initialize(user, search_by)
      @user = user
      @search_by = search_by
    end

    def call
      ticket_assigned_to_user
    end

    private

    attr_reader :user, :search_by

    def ticket_assigned_to_user
      change_order(Ticket.user_assigned_tickets(user).ransack(search_by).result)
    end
  end
end