module TicketManager
  class NewRaisedTicketFinder < ApplicationService
    def initialize(user, search_by)
      @user = user
      @search_by = search_by
    end

    def call
      new_raised_ticket
    end

    private

    attr_reader :user, :search_by

    def new_raised_ticket
      change_order(Ticket.new_request_tickets(user).ransack(search_by).result)
    end
  end
end