class Message < ApplicationRecord
    belongs_to :chats

    auto_increment :message_number, scope:chat_id
end
