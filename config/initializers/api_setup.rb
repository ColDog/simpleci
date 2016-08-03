Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,     ENV['GITHUB_KEY'],    ENV['GITHUB_SECRET'],     scope: %W{ read:org repo user public_repo }
  provider :bitbucket,  ENV['BITBUCKET_KEY'], ENV['BITBUCKET_SECRET'],  scope: %W{ repository issue pullrequest account team webhook }, prompt: 'consent'
end

ActiveModelSerializers.config.adapter = :json

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, credentials: true, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

class AppConfig
  attr_accessor :s3_region, :s3_bucket, :base_url

  def initialize
    @s3_region = ENV['S3_REGION'] || 'us-west-2'
    @s3_bucket = ENV['S3_BUCKET'] || 'simplecistorage'
    @base_url = ENV['BASE_URL'] || 'http://localhost:3000'
  end
end

API_CONFIG = AppConfig.new
