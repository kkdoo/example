class Excavator < ApplicationRecord
  belongs_to :ticket

  validates :company_name, :address, :crew_onsite, presence: true
end
