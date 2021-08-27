require 'securerandom'

class Chat < ActiveRecord::Base

has_many :messages
has_many :users, through: :messages

before_create :add_uuid

  def add_uuid
    self.uuid = SecureRandom.uuid
  end

  def add_message(body, user_id)
    self.messages.create(body: body, user_id: user_id)
  end

  def unique_users
    self.users.uniq.sort_by(&:username)
  end
end
