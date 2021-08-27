class AddVisibleToMessages < ActiveRecord::Migration[6.1]
  def change
  	add_column :messages, :visible, :boolean, default: :true
  end
end
