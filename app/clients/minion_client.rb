class MinionClient

  def initialize(url, job=nil)
    @url = url
    @job = job
  end

  def output_url
    if @job.complete
      "https://s3-#{API_CONFIG.s3_region}.amazonaws.com/#{API_CONFIG.s3_bucket}/builds/#{@job.repo[:owner]}/#{@job.repo[:name]}/#{@job.key}"
    elsif @job.worker.present?
      "#{@job.worker}/current-state"
    end
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
