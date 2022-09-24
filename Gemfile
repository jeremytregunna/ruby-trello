source 'https://rubygems.org'

if active_model_version = ENV['ACTIVE_MODEL_VERSION']
  gem 'activemodel', active_model_version
end

gemspec

group :development, :spec do
  gem 'matrixeval-ruby'
  gem 'rake'
  gem 'rspec', '~> 3.5.0'
  gem 'webmock'
  gem 'launchy'
  gem 'vcr'
  gem 'dotenv'

  if RUBY_VERSION  < '2.6.0'
    gem 'faraday', '~> 1.0'
  else
    gem 'faraday', '~> 2.0'
  end

  gem 'rest-client', '>= 1.8.0'

  if RUBY_ENGINE == 'jruby'
    gem 'jruby-openssl', platforms: :jruby
    gem 'pry-nav', platforms: :jruby
  else
    gem 'pry-byebug', '~> 3.9.0', :platforms => [:mri]
  end
  gem 'simplecov', :require => false, :platforms => [:mri, :mri_18, :mri_19, :jruby, :mingw]
end
