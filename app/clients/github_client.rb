class GithubClient

  def initialize(token)
    @token = token
  end

  def teams
    req(:get, 'user/orgs').map do |org|
      {id: org['id'], name: org['login']}
    end
  end

  def register_webhook(username, repo)
    req(:post, "/repos/#{username}/#{repo}/hooks", {
        name: "cisimple-hook-#{repo}",
        active: true,
        events: ['push'],
        config: {
            url: "#{BASE_URL}/hooks/github",
            content_type: 'json'
        }
    })
  end

  def req(method, url, params={})
    res = conn.send(method, url, params)
    JSON.parse(res.body)
  end

  def conn
    @github ||= Faraday.new(url: 'https://api.github.com/') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.headers['Authorization'] = "token #{@token}"
    end
  end

end
