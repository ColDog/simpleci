require 'test_helper'

class EnqueueJobsTest < ActionDispatch::IntegrationTest

  test 'creating and enqueuing job definition' do
    user = User.first

    job_definition = user.job_definitions.create!(
        name: 'test',

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

    res = EnqueueJobCommand.new(user, job_definition).run('master')
    puts res
  end

  test 'event triggering test' do

  end

end
