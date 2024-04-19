class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :chat_number, unsigned:true
      t.integer :messages_count, default:0, unsigned:true
      t.references :application, null:false, foreign_key:true
      t.timestamps
    end
    add_index :chats, :chat_number, name: "index_chats_on_chat_number"
  end
end
