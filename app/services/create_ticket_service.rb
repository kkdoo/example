class CreateTicketService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    @ticket = Ticket.new(ticket_params(params))
    @ticket.build_excavator(excavator_params(params[:Excavator]))
    @ticket.save!

    [@ticket.as_json(include: :excavator), 200]
  rescue ActiveRecord::RecordInvalid
    [{errors: @ticket.errors.full_messages}, 400]
  end

  protected
  def ticket_params(data)
    {
      request_number: data[:RequestNumber],
      sequence_number: data[:SequenceNumber],
      request_type: data[:RequestType],
    }.merge(datetimes_params(data[:DateTimes]))
     .merge(service_area_params(data[:ServiceArea]))
     .merge(excavation_info(data[:ExcavationInfo]))
  end

  def datetimes_params(data)
    data ||= {}
    {
      response_due: data[:ResponseDueDateTime]
    }
  end

  def service_area_params(data)
    data ||= {}
    {
      primary_sacode: (data[:PrimaryServiceAreaCode] || {})[:SACode],
      additional_sacodes: (data[:AdditionalServiceAreaCodes] || {})[:SACode]
    }
  end

  def excavation_info(data)
    data ||= {}
    {
      well_known_text: (data[:DigsiteInfo] || {})[:WellKnownText]
    }
  end

  def excavator_params(data)
    data ||= {}
    {
      company_name: data[:CompanyName],
      address: [data[:Address], data[:City], data[:State], data[:Zip]].compact.join(', '),
      crew_onsite: data[:CrewOnsite]
    }
  end
end
