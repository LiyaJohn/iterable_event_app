class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_iterable_user

  private

  def create_iterable_user
    body = { email: email }
    IterableService.new(ENV['ITERABLE_API_KEY']).create_user(body)
  end
end
