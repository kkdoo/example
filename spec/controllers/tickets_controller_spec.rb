require 'rails_helper'

describe TicketsController, type: :controller do
  context '#index' do
    let(:subject) { get :index }

    it 'assigns tickets' do
      create(:ticket)

      expect(subject).to render_template(:index)
      expect(assigns(:tickets)).to be_present
    end
  end

  context '#show HTML' do
    let(:ticket) { create(:ticket) }
    let(:subject) { get :show, params: {id: ticket.id.to_param} }

    it 'render ticket' do
      expect(subject).to render_template(:show)

      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  context '#show JSON' do
    let(:ticket) { create(:ticket) }
    let(:subject) { get :show, params: {id: ticket.id.to_param}, format: :json }

    it 'render GeoJson' do
      expect(subject).to_not render_template(:show)

      expect(assigns(:ticket)).to eq(ticket)
      json = JSON.parse(response.body)
      ticket_with_poly = Ticket.with_poly.find(ticket.id)
      expect(json).to eq(ticket_with_poly.poly_json.deep_stringify_keys)
    end
  end
end
