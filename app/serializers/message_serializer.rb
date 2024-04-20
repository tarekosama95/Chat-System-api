class MessageSerializer
  include JSONAPI::Serializer
  attributes :body, :message_number

  def self.only_attributes(messages)
    messages.map do |message|
      {
        message_number: message.message_number,
        body: message.body,
        chat_number: message.chat.chat_number,
        application_name: message.chat.application.name,
        created_at: message.created_at,
        updated_at: message.updated_at
      }
    end
  end
end
