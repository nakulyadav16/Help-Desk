module TicketManager
  class UserFinder < ApplicationService
    def initialize(params)
      @department_id = params[:department_selected_option]
    end

    def call
      fetch_user
    end

    private

    attr_reader :department_id

    def fetch_user
      department_users = Department.find_by_id(department_id).users
      if department_users.count != 0
        role = Role.find_by_id(department_users.first.roles.first.id)
        department_role_herarchicy = create_department_role_herarchicy(role)
        return find_user(department_role_herarchicy, department_users)
      end
    end

    def create_department_role_herarchicy(role)
      role.path.pluck(:name).concat(role.descendants.pluck(:name)).reverse
    end

    def find_user(department_role_herarchicy, department_users)
      department_role_herarchicy.each do |role|
        if (department_users.with_role role).present?
          return (department_users.with_role role)
        end
      end
    end
  end
end