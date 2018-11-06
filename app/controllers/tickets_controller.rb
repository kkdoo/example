class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all
  end

  def show
    @ticket = Ticket.with_poly.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @ticket.poly_json }
    end
  end
end
