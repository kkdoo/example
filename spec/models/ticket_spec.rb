require 'rails_helper'

describe Ticket, type: :model do
  describe 'factory' do
    it 'should be valid' do
      expect(build(:ticket)).to be_valid
    end
  end

  it { should validate_presence_of(:request_number) }
  it { should validate_presence_of(:sequence_number) }
  it { should validate_presence_of(:request_type) }
  it { should validate_presence_of(:response_due) }
  it { should validate_presence_of(:primary_sacode) }
  it { should validate_inclusion_of(:request_type).in_array(Ticket::REQUEST_TYPES) }
  it { should validate_uniqueness_of(:sequence_number) }

  context '#request_number' do
    let(:subject) { build(:ticket) }

    it 'match format' do
      ['asd', '123', '-12321', '31231-', 'asd321-312', '321-asd321'].each do |value|
        subject.request_number = value
        is_expected.to_not be_valid
        expect(subject.errors.messages[:request_number]).to include('is invalid')
      end
      subject.request_number = '123-321'
      subject.valid?
      expect(subject.errors.messages[:request_number]).to be_empty
    end
  end

  it { should have_one(:excavator) }

  context '#request_type=' do
    let(:subject) { build(:ticket) }

    it 'should be in lowercased' do
      subject.request_type = 'Normal'
      expect(subject.request_type).to eq('normal')
      is_expected.to be_valid
    end
  end

  it '#with_poly scope' do
    ticket = create(:ticket)
    polyfied = Ticket.with_poly.find(ticket.id)
    expect(polyfied.poly).to be_kind_of(RGeo::Geos::CAPIPolygonImpl)
  end

  it '#poly_json' do
    ticket = create(:ticket)
    polyfied = Ticket.with_poly.find(ticket.id)
    expect(polyfied.poly_json).to eq({
      features: [
        {
          geometry: {
            "coordinates" => [[[-81.13390268058475, 32.07206917625161], [-81.14660562247929, 32.04064386441295], [-81.08858407706913, 32.02259853170128], [-81.05322183341679, 32.02434500961698], [-81.05047525138554, 32.042681017283066], [-81.0319358226746, 32.06537765335268], [-81.01202310294804, 32.078469305179404], [-81.02850259513554, 32.07963291684719], [-81.07759774894413, 32.07090546831167], [-81.12154306144413, 32.08806865844325], [-81.13390268058475, 32.07206917625161]]],
            "type"=>"Polygon"
          },
          type: "Feature"
        }
      ],
      :type=>"FeatureCollection"
    })
  end
end
