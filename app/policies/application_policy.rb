class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, _record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = _record
    @role = user.roles.first.name
    # @admin = ["IT Director", "Employee", "Staff", @user.name]
  end
  # class 
  # def included_in? array
  #   array.to_set.superset?(self.to_set)
  # end


  class Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user = user
      @scope = scope
      @role = user.roles.first.name
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

  end
end
