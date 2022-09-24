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

  gem 'rest-client', '>= 1.8.0'

  gem 'pry-byebug', '~> 3.9.0', :platforms => [:mri]
  gem 'simplecov', :require => false, :platforms => [:mri, :mri_18, :mri_19, :mingw]
end
