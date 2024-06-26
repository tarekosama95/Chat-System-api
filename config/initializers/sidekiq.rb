redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'
Sidekiq.configure_server do |config|
    config.redis = { url: redis_url }
    config.on(:startup) do
        ChatMessagesCountWorker.perform_in(2.minutes)
        ApplicationsChatCountWorker.perform_in(2.minutes)
    end
end

Sidekiq.configure_client do |config|
    config.redis = { url: redis_url }
end