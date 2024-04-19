class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :message_number,unsigned:true
      t.references :chat, foreign_key:true,index:true
      t.timestamps
    end
  end
end
