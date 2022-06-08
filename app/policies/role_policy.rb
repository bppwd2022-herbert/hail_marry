class RolePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, _record)
    @user = user
    @record = _record
    @role = user.roles.first.name
  end

  def show?
    if @role == "IT Director"
      true
    elsif @role == "Employee"
      if record.name != "IT Director" && record.name != "Employee"
        true
      else
        false
      end
    else
      false
    end
  end

  def edit?
    if @role == "IT Director"
      true
    elsif @role == "Employee"
      if record.name != "IT Director" && record.name != "Employee"
        true
      else
        false
      end
    else
      false
    end
  end

  def update?
    if @role == "IT Director"
      true
    elsif @role == "Employee"
      if record.name != "IT Director" && record.name != "Employee"
        true
      else
        false
      end
    else
      false
    end
  end

  def destroy?
    if @role == "IT Director"
      true
    elsif @role == "Employee"
      if record.name != "IT Director" && record.name != "Employee"
        true
      else
        false
      end
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
        scope.where(roles: {name: ["Teacher", "Student", "Employee"]}).order('id')
      end
    end
  end
end
