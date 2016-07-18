ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def sample_job_def
    {
        name: 'test',

        triggered_by: %w(git:push:ci-sample.* test.*),

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
    }
  end

end
