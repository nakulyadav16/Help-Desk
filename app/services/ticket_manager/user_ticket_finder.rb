module TicketManager
  class UserTicketFinder < ApplicationService
    def initialize(user, search_by)
      @user = user
      @search_by = search_by
    end

    def call
      ticket_created_by_user
    end

    private

    attr_reader :user, :search_by

    def ticket_created_by_user
      change_order(user.tickets.ransack(search_by).result)
    end
  end
end