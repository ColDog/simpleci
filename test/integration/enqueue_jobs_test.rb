require 'test_helper'

class EnqueueJobsTest < ActionDispatch::IntegrationTest

  test 'creating and enqueuing job definition' do
    user = User.first

    job_definition = user.job_definitions.create!(
        name: 'test',

        triggered_by: 'stuff',

        repo: {
            owner: 'coldog',
            project: 'ci-sample'
        },

        build: {
            build: {
                env: {
                    TEST: 'true'
                },
                base_image: 'ubuntu',
                before: ['echo "hello"'],
                main: ['echo "hello from main"'],
                after: ['echo "hello from after"'],
                on_success: ['echo "hello from on_success"'],
                on_failure: ['echo "hello from on_failure"'],
            }
        }
    )

    EnqueueJobCommand.new(user, job_definition).run(branch: 'master')
  end

  test 'event triggering test' do
    user = User.first
    user.job_definitions.create!(sample_job_def.merge(triggered_by: ['test.*']))

    Event.create(name: 'test.stuff', payload: {branch: 'master'}, user_id: user.id)

    assert_difference 'Job.count', +1 do
      EventWorker.run_one_job
    end
  end

end
