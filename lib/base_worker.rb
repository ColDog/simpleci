class BaseWorker
  cattr_accessor :max_attempts, :poll_time

  self.max_attempts = 25
  self.poll_time = 5

  def self.uuid
    @uuid ||= "worker-#{rand(0..10000000)}"
  end

  def self.queue(model)
    @queue ||= model
  end

  def self.next_job
    @queue.where(worker: nil).limit(1).update(worker: uuid).first
  end

  def self.size
    @queue.where(worker: nil).count
  end

  def self.run_one_job
    run(max_count: 1, raise_errors: true)
  end

  def self.run(max_count: nil, raise_errors: false)
    count = 0
    begin

      loop do
        current = next_job

        if current
          count += 1
          begin
            t1 = Time.now
            self.new.perform(current)
            current.destroy!
            t2 = Time.now
            Rails.logger.info "performed job in #{t2 - t1}"

          rescue SystemExit, Interrupt, SignalException => e
            raise e

          rescue Exception => e
            if current.attempts > max_attempts
              current.update(failed: true)
            else
              current.update(last_error: e.backtrace.join("\n"), attempts: current.attempts + 1, worker: nil)
            end

            if raise_errors
              raise e
            end

          end
        end

        if max_count && count >= max_count
          quit
          return
        end

        sleep(poll_time)
      end

    rescue Exception => e
      if raise_errors
        raise e
      else
        Rails.logger.warn "exiting due to: #{e.message}"
        quit
        return
      end
    end
  end

  def self.quit
    @queue.where(worker: uuid).update(worker: nil)
  end

end
