require 'test_helper'

class EnqueueJobsTest < ActionDispatch::IntegrationTest

  test 'enqueue a job' do
    repo = repos(:one)
    cmd = EnqueueJobCommand.new(users(:one), repo)
    assert_equal 'ubuntu', cmd.builds[0][:base_image]

    conf = Config.create!(name: 'main', body: {
        build: {
            base_image: 'ruby-2.3.0'
        }
    })

    repo.update!(config_id: conf.id)

    cmd = EnqueueJobCommand.new(users(:one), repo.reload)
    assert cmd.builds[0][:base_image].present?

  end

end
