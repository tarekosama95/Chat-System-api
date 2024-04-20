class ChatMessagesCountWorker
    require 'redis'
    include Sidekiq::Worker

    def perform
        redis = Redis.new
        chats_ids = redis.smembers('chats_to_update')
        chats_ids do |chat_id|
            @chat = Chat.find(chat_id)
            if @chat
            message_count = Message.where(chat_id: @chat.id).count
            @chat.update!(messages_count: messages_count)
            redis.srem("chats_to_update", @chat.id)
            end
        end
        self.perform_in(30.seconds)
    end
end