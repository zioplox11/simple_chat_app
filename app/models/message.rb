class Message < ActiveRecord::Base

belongs_to :chat
belongs_to :user

scope :visible, -> { where(visible: true) }

end
