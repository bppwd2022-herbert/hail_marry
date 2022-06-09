class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :rentable, polymorphic: true
  def rentable_sgid
    self.rentable&.to_signed_global_id
  end
  def rentable_sgid=(sgid)
    self.rentable = GlobalID::Locator.locate_signed(sgid)
  end

end
