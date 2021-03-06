class GithubClient

  def initialize(username, token)
    @token = token
    @username = username
  end

  def teams
    req(:get, 'user/orgs').map do |org|
      {id: org['id'], name: org['login']}
    end
  end

  def repo(repo)
    req(:get, "/repos/#{@username}/#{repo}")
  end

  def branches(repo)
    req_cached(:get, "/repos/#{@username}/#{repo}/branches")
  end

  def file(repo, path)
    res = req(:get, "/repos/#{@username}/#{repo}/contents/#{path}")
    Base64.decode64(res['content']) if res['content']
  end

  def ci_yml(repo)
    res = file(repo, 'ci.yml')
    HashWithIndifferentAccess.new(YAML.load(res)) if res
  end

  def register_webhook(repo)
    post_json("/repos/#{@username}/#{repo}/hooks", {
        name: 'web',
        active: true,
        events: %w(push pull_request),
        config: {
            url: "#{API_CONFIG.base_url}/hooks/github",
            content_type: 'json'
        }
    })
  end

  protected

  def req(method, url, params={})
    puts "#{method}  https://api.github.com/#{url}"
    res = conn.send(method, url, params)
    JSON.parse(res.body)
  end

  def post_json(url, payload)
    res = conn.post do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate(payload)
    end
    JSON.parse(res.body)
  end

  def req_cached(method, url, params={})
    Rails.cache.fetch("github-api:#{method}.#{url}") { req(method, url, params) }
  end

  def conn
    @github ||= Faraday.new(url: 'https://api.github.com/') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.headers['Authorization'] = "token #{@token}"
    end
  end

end
