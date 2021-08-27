class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.string :subject
      t.string :uuid
      t.timestamps
    end
  end
end
