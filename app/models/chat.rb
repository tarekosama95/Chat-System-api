class Chat < ApplicationRecord
    belongs_to :application
    has_many :messages
  
    auto_increment :chat_number, scope: :application_id
end
