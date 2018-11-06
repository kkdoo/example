require 'rails_helper'

describe 'Tickets API' do
  context 'POST /api/tickets' do
    let(:params) {
      File.read(Rails.root.join('spec/data/example.json'))
    }
    let(:headers) {
      { "CONTENT_TYPE" => "application/json" }
    }

    it 'success' do
      expect {
        post '/api/tickets', params: params, headers: headers
      }.to change { Ticket.count }.by(1)

      expect(response.status).to eq(200)

      json = JSON.parse(response.body)
      ticket = Ticket.last

      expect(json['id']).to eq(ticket.id)
    end

    describe 'fail' do
      it 'due to wrong format' do
        expect {
          post '/api/tickets', params: 'something wrong'
        }.to_not change { Ticket.count }
        expect(response.status).to eq(400)
      end

      it 'due to wrong json' do
        expect {
          post '/api/tickets', params: '{a}'
        }.to_not change { Ticket.count }
        expect(response.status).to eq(400)
      end

      it 'due to validations' do
        expect {
          post '/api/tickets', params: '{}'
        }.to_not change { Ticket.count }
        expect(response.status).to eq(400)
      end
    end
  end
end
