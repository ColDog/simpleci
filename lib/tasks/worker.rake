namespace :worker do
  Rails.logger = Logger.new(STDOUT)

  desc "starts the worker for event worker"
  task events: :environment do
    EventWorker.run
  end

end
