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
end
