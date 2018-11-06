class Api::TicketsController < ActionController::API
  def create
    json, status = CreateTicketService.new(params).call
    render json: json, status: status
  end
end
