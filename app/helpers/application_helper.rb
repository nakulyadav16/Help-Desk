module ApplicationHelper
    def get_departments
        Department.pluck(:department_name, :id)
    end

    def get_roles
        Role.pluck(:name)
    end
end
