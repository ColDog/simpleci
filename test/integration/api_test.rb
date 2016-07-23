require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest

  test 'minion authorization' do
    test_user = User.first

    get '/api/users/me', headers: { Authorization: "minion:secret.#{test_user.id}" }
    assert_response :success
    assert_equal 'coldog', JSON.parse(response.body)['user']['username']
  end

  test 'basic authorization' do
    get '/api/users/me', headers: { Authorization: 'test:secret' }
    assert_response :success

    get '/api/users/me', headers: { Authorization: 'test:asdfasdf' }
    assert_response :forbidden
  end

  test 'create a new token' do
    post '/api/users/me/tokens', headers: { Authorization: 'test:secret' }
    token = JSON.parse(response.body)['token']

    get '/api/users/me', headers: { Authorization: "#{token['key']}:#{token['secret']}" }
    assert_response :success

    delete "/api/users/me/tokens/#{token['key']}", headers: {Authorization: "#{token['key']}:#{token['secret']}" }

    get '/api/users/me', headers: { Authorization: "#{token['key']}:#{token['secret']}" }
    assert_response :forbidden
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

    get '/api/users/me/jobs',
        params: { query: { complete: true } },
        headers: { Authorization: 'test:secret' }

    assert_response :success
    assert_not_empty JSON.parse(response.body)['jobs']
  end

end
