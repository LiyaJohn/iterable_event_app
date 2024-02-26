class IterableService
  include HTTParty
  base_uri "#{ENV['ITERABLE_BASE_URI']}"

  attr_reader :options

	def initialize(api_key)
		@options = {
      headers: { 'Content-Type' => 'application/json', 'Api-Key' => api_key }
    }
	end

  def create_user(body)
    self.class.post('/api/users/update', options.merge(body: body.to_json))
  end

  def fetch_events(email)
    response = self.class.get("/api/events/#{email}", options)
    JSON.parse(response.body)
  end

  def create_event(email, event_name)
    body = { 
      email: email,
      eventName: event_name,
      createdAt: DateTime.now,
      dataFields: { source: 'IterableEventApp' }
    }
    self.class.post('/api/events/track', options.merge(body: body.to_json))
  end

  def send_email(email, event_name)
    body = {
      campaignId: 12345, # Assuming we have a campaign with id 12345 set up in iterable
      recipientEmail: email,
      dataFields: {
        source: 'IterableEventApp',
        eventName: event_name
      }
    }
    self.class.post('/api/email/target', options.merge(body: body.to_json))
  end
end