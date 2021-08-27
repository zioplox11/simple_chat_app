class AddUuidToChats < ActiveRecord::Migration[6.1]
  def change
  	add_column :chats, :uuid, :string
  end
end
