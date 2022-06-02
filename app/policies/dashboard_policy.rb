class DashboardPolicy
    attr_reader :user, :record

    def initialize(user, _record)
        @user = user
        @record = _record
        @role = user.roles.first.name
    end

    def create?
        @role == "IT Director" || @role == "Employee"
    end

    def new?
        @role == "IT Director" || @role == "Employee"
    end

    def show?
        @role == "IT Director" || @role == "Employee"
    end

    def index?
        @role == "IT Director" || @role == "Employee"
    end

    def edit?
        @role == "IT Director" || @role == "Employee"
    end

    def update?
        @role == "IT Director" || @role == "Employee"
    end

    def destroy?
        @role == "IT Director" || @role == "Employee"
    end
end
