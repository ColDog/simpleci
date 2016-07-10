class GithubClient

  def initialize(token)
    @token = token
  end

  def teams
    req(:get, 'user/orgs').map do |org|
      {id: org['id'], name: org['name']}
    end
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