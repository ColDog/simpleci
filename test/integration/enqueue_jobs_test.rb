require 'test_helper'

class EnqueueJobsTest < ActionDispatch::IntegrationTest

  test 'enqueue a job' do
    repo = repos(:one)
    cmd = EnqueueJobCommand.new(users(:one), repo)
    puts "config: #{cmd.builds}"
    cmd.builds

    conf = Config.create!(name: 'main', body: {
        build: {
            base_image: 'ruby-2.3.0'
        }
    })

    repo.update!(config_id: conf.id)

    cmd = EnqueueJobCommand.new(users(:one), repo.reload)
    puts "config: #{cmd.builds}"
    cmd.builds

  end

end
