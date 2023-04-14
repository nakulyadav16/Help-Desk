module TicketManager
  class PerformTransistion < ApplicationService
    def initialize(transistion, ticket)
      @transistion = transistion
      @ticket = ticket
    end

    def call
      perform_transistion
    end

    private

    attr_reader :transistion, :ticket

    def perform_transistion
      case transistion
      when 'accept'
        ticket.accept!
      when 'reject'
        ticket.reject!
      when 'satisfy'
        ticket.satisfy!
      when 'close'
        ticket.close!
      else
        raise ArgumentError
      end
      return true
      rescue ArgumentError
        false
    end
  end
end