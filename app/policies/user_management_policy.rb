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

  def edit?
    if @role == "IT Director"
      true
    elsif @role == "Employee" && record.roles.first.name != "Employee" && record.roles.first.name != "IT Director"
      true
    else
      false
    end
  end

  def update?
    if @role == "IT Director"
      true
    elsif @role == "Employee" && record.name != "Employee" && record.name != "IT Director"
      true
     else
      false
    end
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
      @role = user.roles.first.name
    end

    def resolve
      if @role == "IT Director"
        scope.all.order('id')
      elsif @role == "Employee"
        if scope == User
          scope.joins(:roles).where(roles: {name: ["Teacher", "Student", "Employee"]}).order('role_id, id ASC')
        elsif scope == Role
          scope.where(roles: {name: ["Teacher", "Student"]}).order('id')
        end
      end
    end
  end
end
