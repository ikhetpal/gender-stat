require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    if File.exist?(schedule_file) && Sidekiq.server?
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end

# Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
#   Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(user), ::Digest::SHA256.hexdigest('admin')) &
#   Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest('Test@123'))
# end