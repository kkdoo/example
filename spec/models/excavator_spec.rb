require 'rails_helper'

describe Excavator, type: :model do
  describe 'factory' do
    it 'should be valid' do
      expect(build(:excavator)).to be_valid
    end
  end

  it { should validate_presence_of(:company_name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:crew_onsite) }

  it { should belong_to(:ticket) }
end
