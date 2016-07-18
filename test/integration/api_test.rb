require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest

  test 'basic authorization' do
    get '/api/users/me', headers: { Authorization: 'test:secret' }
    assert_response :success

    get '/api/users/me', headers: { Authorization: 'test:asdfasdf' }
    assert_response :forbidden
  end

  test 'create a new token' do

  end

  test 'job creation cycle' do
    post '/api/users/me/job_definitions',
         params: { job_definition: sample_job_def },
         headers: { Authorization: 'test:secret' }
    assert_response :success

    post '/api/users/me/events',
         params: { event: {name: 'test.event', payload: {branch: 'master'}} },
         headers: { Authorization: 'test:secret' }
    assert_response :success

    assert_difference 'Job.count', +1 do
      EventWorker.run_one_job
    end
  end

end
