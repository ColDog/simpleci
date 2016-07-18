class EventWorker < BaseWorker
  queue Event

  def perform(event)
    event
  end

end
