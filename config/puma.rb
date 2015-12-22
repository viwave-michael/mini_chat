workers Integer(ENV['PUMA_WORKERS'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port   ENV['PORT']          || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # worker specific setup
  config = ActiveRecord::Base.configurations[Rails.env] ||
    Rails.application.config.database_configuration[Rails.env]
  config['pool'] = ENV['MAX_THREADS'] || 5
  ActiveRecord::Base.establish_connection(config)
end