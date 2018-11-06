require 'rails_helper'

describe CreateTicketService, type: :service do
  context 'POST /api/tickets' do
    let(:params) {
      file = File.read(Rails.root.join('spec/data/example.json'))
      json = JSON.load(file)
      ActionController::Parameters.new(json)
    }

    describe 'success' do
      it 'should be success' do
        result = status = nil
        expect {
          result, status = CreateTicketService.new(params).call
        }.to change { Ticket.count }.by(1)

        ticket = Ticket.last

        expect(result).to eq(
          {"id"=>ticket.id,
           "request_number"=>"09252012-00001",
           "sequence_number"=>2421,
           "request_type"=>"normal",
           "response_due"=>"2011-07-13T23:59:59.000Z",
           "primary_sacode"=>"ZZGL103",
           "additional_sacodes"=>["ZZL01", "ZZL02", "ZZL03"],
           "well_known_text"=>
           "POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128,-81.05322183341679 32.02434500961698,-81.05047525138554 32.042681017283066,-81.0319358226746 32.06537765335268,-81.01202310294804 32.078469305179404,-81.02850259513554 32.07963291684719,-81.07759774894413 32.07090546831167,-81.12154306144413 32.08806865844325,-81.13390268058475 32.07206917625161))",
             "excavator"=>
           {"id"=>ticket.excavator.id,
            "ticket_id"=>ticket.id,
            "company_name"=>"John Doe CONSTRUCTION",
            "address"=>"555 Some RD, SOME PARK, ZZ, 55555",
            "crew_onsite"=>true}})
      end
    end

    describe 'fail' do
      it 'due to incomplete parameters' do
        result = status = nil
        expect {
          result, status = CreateTicketService.new({}).call
        }.to_not change { Ticket.count }

        expect(result).to be_key(:errors)
        expect(result[:errors]).to include("Request number is invalid")
      end

      it 'due to validations' do
        params[:RequestNumber] = '123'

        result = status = nil
        expect {
          result, status = CreateTicketService.new(params).call
        }.to_not change { Ticket.count }

        expect(result).to eq({errors: ["Request number is invalid"]})
      end
    end
  end
end

