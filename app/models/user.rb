class User < ActiveRecord::Base

has_secure_password
has_many :messages
has_many :chats, through: :messages

validates :username, presence: :true, uniqueness: :true

  def unique_chats
  	self.chats.uniq
  end
end
