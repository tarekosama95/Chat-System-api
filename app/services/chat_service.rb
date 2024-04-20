class ChatService
    require 'redis'
    def initialize(application)
        @application = application
    end

    def create_chat
        chat_number = redis.incr("max_chat_number_application:#{@application.id}")
        @chat = Chat.create(application_id: @application.id, chat_number: chat_number)
        return @chat
    end

    def redis
        @redis ||=Redis.new
    end
end