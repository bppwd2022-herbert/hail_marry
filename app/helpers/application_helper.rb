module ApplicationHelper
  def get_rentable(rnt)
    @rntable = rnt.rentable_type.constantize.find(rnt.rentable_id)
    return @rntable
  end
  class Array
    
  end
end
