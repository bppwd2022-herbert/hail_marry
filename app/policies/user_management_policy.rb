class UserManagementPolicy < ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, _record)
        @user = user
        @record = _record
        @role = user.roles.first.name
    end

    def assign_roles?
        @role == "IT Director" || @role == "Employee"
    end

    def show?
        user.id == record || @role == "IT Director" || @role == "Employee"
    end

    # class Scope

    # end
end
