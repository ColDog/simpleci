class EventWorker < BaseWorker
  queue Event

  def perform(event)
    event.user.job_definitions.each do |job_def|
      if matches(event.name, job_def.triggered_by)
        EnqueueJobCommand.new(event.user, job_def).run(event.payload)
      end
    end
  end

  def matches(main, test)
    main = main.split('')
    test = test.split('')

    test.each_with_index do |char, idx|
      return true if char == '*'
      return false unless main[idx] == char
    end
  end

end
