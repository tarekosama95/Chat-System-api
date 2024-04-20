class ChatService
    require 'redis'
    def initialize(application)
        @application = application
    end

    def create_chat
        chat_number = redis.incr("max_chat_number_application:#{@application.id}")
        @chat = Chat.create(application_id: @application.id, chat_number: chat_number)
        redis.sadd("applications_to_update",@application.id)
        return @chat
    end

    def redis
        redis_url = ENV['REDIS_URL'] || 'redis://redis:6379/0'
        @redis ||=Redis.new(url: redis_url)
    end
end