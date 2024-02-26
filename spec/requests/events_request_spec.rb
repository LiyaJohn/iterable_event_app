require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let(:email) { 'user@example.com' }
  let(:base_url) { 'https://api.iterable.com' }
  let(:api_key) { 'mock-api-key' }

  before do
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe 'GET /events' do
    context 'when events are fetched successfully' do
      before do
        get '/events', params: { search: 'user' }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @events with the fetched events' do
        expect(assigns(:events).first['email']).to eq('user@example.com')
        expect(assigns(:events).first['contentId']).to eq(1)
      end
    end

    context 'when there is an error fetching events' do
      # WebMock.after_request do |request_signature, response|
      #   puts "Response Body: #{response.body}"
      # end
      before do
        stub_request(:get, "#{base_url}/api/events/#{email}").
          with(headers: { 'Content-Type' => 'application/json', 'Api-Key' => api_key }).
          to_return(status: 500, body: '{"msg": "Internal server error", "code": "InternalServerError"}',
                    headers: { 'Content-Type': 'application/json' })

        get '/events', params: { search: 'user' }
      end

      it 'returns a 500 status code' do
        expect(response).to have_http_status(500)
      end

      it 'renders an error message in the response body' do
        expect(response.body).to include('Internal server error')
      end
    end
  end

  describe 'POST /events/create_event_a' do
    context 'when the event is successfully created' do
      before do
        post '/events/create_event_a'
      end

      it 'redirects to events_path' do
        expect(response).to redirect_to(events_path)
        follow_redirect!
      end

      it 'sets a success flash message' do
        expect(flash[:success]).to eq('Successfully created Event A')
      end
    end

    context 'when there is an error creating the event' do
      before do
        stub_request(:post, "#{base_url}/api/events/track").
          with(headers: { 'Content-Type' => 'application/json', 'Api-Key' => api_key }).
          to_return(status: 500, body: '{"msg": "Internal server error", "code": "InternalServerError"}',
                    headers: { 'Content-Type': 'application/json' })

        post '/events/create_event_a'
      end

      it 'renders an internal server error with the JSON error response' do
        expect(response).to have_http_status(500)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Internal server error', 'code' => 'InternalServerError' })
      end
    end
  end

  describe 'POST /events/create_event_b' do
    context 'when the event is successfully created' do
      before do
        post '/events/create_event_b'
      end

      it 'calls Iterable API to send an email' do
        body = {
          campaignId: 12345,
          recipientEmail: email,
          dataFields: {
            source: 'IterableEventApp',
            eventName: 'emailSend'
          }
        }
        expect(WebMock).to have_requested(:post, "#{base_url}/api/email/target")
          .with(
            headers: { 'Content-Type' => 'application/json', 'Api-Key' => api_key },
            body: body.to_json
          ).once
      end

      it 'redirects to events_path' do
        expect(response).to redirect_to(events_path)
        follow_redirect!
      end

      it 'sets a success flash message' do
        expect(flash[:success]).to eq('Successfully created Event B and started processing the email notification')
      end
    end

    context 'when there is an error creating the event' do
      before do
        stub_request(:post, "#{base_url}/api/events/track").
          with(headers: { 'Content-Type' => 'application/json', 'Api-Key' => api_key }).
          to_return(status: 500, body: '{"msg": "Internal server error", "code": "InternalServerError"}',
                    headers: { 'Content-Type': 'application/json' })

        post '/events/create_event_b'
      end

      it 'renders an internal server error with the JSON error response' do
        expect(response).to have_http_status(500)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Internal server error', 'code' => 'InternalServerError' })
      end
    end
  end
end
