class EventsController < ApplicationController
  include EventsHelper

	def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    response = iterable_service.fetch_events(current_user.email)
    if !response['events'].nil?
      @events = response['events']
      @events = filtered_events(params[:search].downcase) if params[:search].present?
      @events = Kaminari.paginate_array(@events).page(page).per(per_page)
    else
      render json: { error: response['msg'], code: response['code'] }, status: :internal_server_error
    end
  end

  def create_event_a
    response = iterable_service.create_event(current_user.email, 'buttonClick')
    if response.success?
      flash[:success] = 'Successfully created Event A'
      redirect_to events_path
    else
      response_body = JSON.parse(response.body)
      render json: { error: response_body['msg'], code: response_body['code'] }, status: :internal_server_error
    end
  end

  def create_event_b
    response = iterable_service.create_event(current_user.email, 'emailSend')
    if response.success?
      iterable_service.send_email(current_user.email, 'emailSend')
      flash[:success] = 'Successfully created Event B and started processing the email notification'
      redirect_to events_path
    else
      response_body = JSON.parse(response.body)
      render json: { error: response_body['msg'], code: response_body['code'] }, status: :internal_server_error
    end
  end

  private

  def iterable_service
    @iterable_service ||= IterableService.new(ENV['ITERABLE_API_KEY'])
  end

  def filtered_events(search)
    @events.select do |event|
      event.values.any? { |value| value.to_s.downcase.include?(search) }
    end
  end
end