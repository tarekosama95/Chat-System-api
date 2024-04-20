class ApplicationsChatCountWorker
    require 'redis'
    include Sidekiq::Worker

    def perform
        begin
        redis = Redis.new
        applications_ids = redis.smembers('applications_to_update')

        applications_ids.each do |application_id|
            Application.transaction do
            @application = Application.find(application_id)
            if @application
                Rails.logger.info "Starting Update Application : #{@application.id}"
                chats = Chat.where(application_id: @application.id).count
                Rails.logger.info "Total chats : #{chats}"
                @application.update!(chats_count: chats)
                Rails.logger.info "After Updating : #{@application.reload.chats_count}"
                redis.srem("applications_to_update", @application.id)
                    end
                end
            end
            rescue => e
                Rails.logger.info "Error #{e.message}"
            end
        end
end