module UserManagementHelper
    def get_rentable(rnt)
        @rntable = rnt.rentable_type.constantize.find(rnt.rentable_id)
        return @rntable
    end
end
