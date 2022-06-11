class DashboardPolicy < ApplicationPolicy
  def create?
    @role == "IT Director" || @role == "Employee" || @role == "Staff"
  end

  def new?
    @role == "IT Director" || @role == "Employee" || @role == "Staff"
  end

  def show?
    @role != "Student"
  end

  def index?
    @role != "Student"
  end

  def update?
    @role == "IT Director" || @role == "Employee" || @role == "Staff"
  end

  def destroy?
    @role == "IT Director" || @role == "Employee" || @role == "Staff"
  end
end

