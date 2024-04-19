class ApplicationSerializer
  include JSONAPI::Serializer
  attributes :name, :token, :chats_count, :created_at, :updated_at

  attribute :chats_count do |object|
    "No.of_chats"
  end
end
