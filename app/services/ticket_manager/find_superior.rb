module TicketManager
  class FindSuperior < ApplicationService
    def initialize(ticket)
      @ticket = ticket
    end

    def call
      assign_ticket_to_superior
    end

    private

    attr_reader :ticket

    def assign_ticket_to_superior
      old_assigned_user_id = ticket.assigned_to_id
      department_users = Department.includes(users: :roles).find_by_id(ticket.department_id).users
      superior_role_hierarchy = create_superior_role_hierarchy(ticket)
      ticket.assigned_to_id = find_superior(superior_role_hierarchy, department_users)
      ticket.assigned_to_id != old_assigned_user_id
    end

    def create_superior_role_hierarchy(ticket)
      ticket.assigned_to.roles.first.ancestors.pluck(:name).reverse
    end

    def find_superior(superior_role_hierarchy, department_users)
      superior_role_hierarchy.each do |role|
        users = department_users.with_role(role)
        if users.any?
          return users.sample.id
        end
      end
    end
  end
end