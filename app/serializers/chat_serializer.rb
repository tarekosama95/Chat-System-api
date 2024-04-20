
class ChatSerializer
  include JSONAPI::Serializer

  attributes :chat_number, :messages_count

  def self.only_attributes(chats)
    chats.map do |chat|
      {
        chat_number: chat.chat_number,
        messages_count: chat.messages_count,
        application_name: chat.application.name,
        created_at: chat.created_at,
        updated_at: chat.updated_at
      }
    end
  end
end