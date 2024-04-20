class ApplicationChatCountWorker
    require 'redis'
    include Sidekiq::Worker

    def perform
        redis = Redis.new
        applications_ids = redis.smembers('applications_to_update')

        applications_ids do |application_id|
            @application = Application.find(application_id)
            if @application
            chats_count = Chat.where(application_id: @application.id)
            @application.update!(chats_count: chats_count)
            redis.srem("applications_to_update", @chat.id)
            end
        end
        self.perform_in(30.seconds)
    end
end