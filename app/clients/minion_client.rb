class MinionClient

  def initialize(url)
    @url = url
  end

  def cancel
    conn.post('/cancel').status == 200
  end

  def output
    JSON.parse(conn.get('/current-state').body)
  end

  def conn
    @conn ||= Faraday.new(url: @url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

end
