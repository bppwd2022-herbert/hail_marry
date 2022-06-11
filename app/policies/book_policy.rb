class BookPolicy < ApplicationPolicy
  def low?
    @role != "Student"
  end

  def mid?
    # puts @admin[3]
    # puts "===================================="
    # puts @record.teacher
    # puts "===================================="
    # puts [@record.teacher, @role].included_in?(@admin)
    # puts "===================================="
    true
    # @role == "IT Director" || @role == "Employee" || @role == "Staff" || @record == @user.name
  end

end