class MessageService
    require 'redis'
    def initialize(chat, message_params)
        @chat = chat
        @message_params = message_params
    end

    def create_message
        message_number = redis.incr("max_messages_number_chat:#{@chat.id}")
        @message = Message.create(chat_id: @chat.id, message_number: message_number, body: @message_params)
        redis.sadd("chats_to_update",@chat.id)
        return @message
    end

    def redis
        redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'
        @redis ||=Redis.new(url: redis_url)
    end
end