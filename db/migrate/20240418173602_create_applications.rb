class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token
      t.integer :chats_count, default:0,unsigned:true
      t.timestamps
    end
    add_index :applications, :token, name: "index_applications_on_token"
  end
end
