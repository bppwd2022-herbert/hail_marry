class RolePolicy < ApplicationPolicy
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

  class Scope < Scope
    def resolve
      if @role == "IT Director"
        scope.all.order('id')
      elsif @role == "Employee"
        scope.where(roles: {name: ["Teacher", "Student", "Employee"]}).order('id')
      end
    end
  end
end
