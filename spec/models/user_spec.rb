require 'rails_helper'
require 'json'

RSpec.describe User, type: :model do
  describe 'after_create callback' do
    it 'calls Iterable API to create a user' do
      api_key = 'mock-api-key'
      base_url = 'https://api.iterable.com'
      user_data = { email: 'user@example.com' }

      user = User.create(user_data.merge(password: 'Example123'))

      expect(WebMock).to have_requested(:post, "#{base_url}/api/users/update")
        .with(
          headers: { 'Content-Type' => 'application/json', 'Api-Key' => api_key },
          body: user_data.to_json
        ).once
    end
  end
end