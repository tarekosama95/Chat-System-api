class ChatMessagesCountWorker
    require 'redis'
    include Sidekiq::Worker

    def perform
        begin
        redis = Redis.new
        chats_ids = redis.smembers('chats_to_update')
        Rails.logger.info "Chat ids found are: #{chats_ids}"

        chats_ids.each do |chat_id|
            Chat.transaction do
            @chat = Chat.find(chat_id)
            if @chat
                Rails.logger.info "Starting Update Chat : #{@chat.id}"
                messages = @chat.messages.count
                Rails.logger.info "Total messages : #{messages}"
                @chat.update!(messages_count: messages)
                Rails.logger.info "After Updating : #{@chat.reload.messages_count}"
                redis.srem("chats_to_update", @chat.id)
                    end
                end
            rescue => e
                 Rails.logger.info "Error #{e.message}"
                return e.message
            end
        end
    end
end