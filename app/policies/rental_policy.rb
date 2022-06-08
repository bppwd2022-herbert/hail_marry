class RentalPolicy < ApplicationPolicy
  attr_reader :user, :record
  
  def initialize(user, _record)
    @user = user
    @record = _record
    @role = user.roles.first.name
  end

  def index?
    ['IT Director', 'Employee', 'Teacher', 'Coach'].include? @role
  end

  def resolve
    raise NotImplementedError, "You must define #resolve in #{self.class}"
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
        scope.where(rentable_type: ["Book", "Item"]).order('id')
      elsif @role == "Teacher"
        scope.where(rentable_type: ["Book", "Van"]).order('id')
      elsif @role == "Coach"
        scope.where(rentable_type: "Van").order('id')
      end
    end
  end
end


# if @usrole.name == "Teacher" || @usrole.name == "Employee" || @usrole.name == "IT Director"
# if @usrole.name == "Employee" || @usrole.name == "IT Director"
# end
# end
# if @usrole.name != "Employee"
# end