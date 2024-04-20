class ApplicationSerializer
  include JSONAPI::Serializer
  attributes :chat_number, :messages_count

  def self.only_attributes(applications)
    applications.map do |application|
      {
        application_name: application.name,
        application_token: application.token,
        chats_count: application.chats_count,
        created_at: application.created_at,
        updated_at: application.updated_at
      }
    end
  end
end
