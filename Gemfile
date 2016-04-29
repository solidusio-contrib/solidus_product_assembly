source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch

group :development, :test do
  gem 'solidus_auth_devise'
  gem 'pry-rails'
end

gemspec
