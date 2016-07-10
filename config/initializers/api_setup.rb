Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,     ENV['GITHUB_KEY'],    ENV['GITHUB_SECRET'],     scope: %W{ read:org repo user public_repo }
  provider :bitbucket,  ENV['BITBUCKET_KEY'], ENV['BITBUCKET_SECRET'],  scope: %W{ repository issue pullrequest account team webhook }, prompt: 'consent'
end

BASE_URL = 'http://localhost:3000'
