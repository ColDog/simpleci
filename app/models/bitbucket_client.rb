class BitbucketClient

  def initialize(token)
    @token = token
  end

  def teams
    req(:get, '2.0/user/orgs').map do |org|
      {id: org['id'], name: org['name']}
    end
  end

  def req(method, url, params={})
    res = conn.send(method, url, params)
    JSON.parse(res.body)
  end

  def refresh

  end

  def conn
    @github ||= Faraday.new(url: 'https://api.bitbucket.org/') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.response :logger                  # log requests to STDOUT
      faraday.headers['Authorization'] = "Bearer #{@token}"
    end
  end

end