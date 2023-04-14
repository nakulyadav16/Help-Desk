module TicketManager
  class TicketHistories < ApplicationService
    def initialize(ticket)
      @ticket = ticket
    end

    def call
      ticket_history
    end

    private

    attr_reader :ticket

    def ticket_history
      ticket.ticket_histories
             .joins(:user)
             .select('users.name', :created_at)
             .map { |history| [history.name, history.created_at] }
    end
  end
end