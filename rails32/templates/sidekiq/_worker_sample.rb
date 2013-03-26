class worker_name
  include Sidekiq::Worker
  sidekiq_options retry: false #:retry => 1, :queue => :special_queue

  def perform #param1, param2, ...
    # some heavy job here
  end

end