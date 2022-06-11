class RentalPolicy < ApplicationPolicy

  def index?
    ['IT Director', 'Employee', 'Teacher', 'Coach'].include? @role
  end

  class Scope < Scope
    
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