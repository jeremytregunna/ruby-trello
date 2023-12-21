Gem::Specification.new do |s|
  s.name              = %q{ruby-trello}
  s.version           = "4.2.0"
  s.platform          = Gem::Platform::RUBY
  s.license           = 'MIT'

  s.authors           = ["Jeremy Tregunna"]
  s.date              = Time.now.strftime "%Y-%m-%d"
  s.description       = %q{A wrapper around the trello.com API.}
  s.email             = %q{jeremy@tregunna.ca}
  s.extra_rdoc_files  = ["README.md"]
  s.files             = Dir.glob("lib/**/*") + %w(README.md)
  s.homepage          = %q{https://github.com/jeremytregunna/ruby-trello}
  s.rdoc_options      = ["--charset=UTF-8"]
  s.require_paths     = ["lib"]
  s.rubygems_version  = %q{1.3.5}
  s.summary           = %q{A wrapper around the trello.com API.}
  s.test_files        = Dir.glob("spec/**/*")
  s.metadata['changelog_uri'] = 'https://github.com/jeremytregunna/ruby-trello/blob/master/CHANGELOG.md'

  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'activemodel', '>= 6.0.0'
  s.add_dependency 'addressable', '~> 2.3'
  s.add_dependency 'json', '>= 2.3.0'
  s.add_dependency 'oauth', '>= 0.4.5'
  s.add_dependency 'faraday', '~> 2.0'
  s.add_dependency 'faraday-multipart', '~> 1.0'
  s.add_dependency('mime-types', '>= 3.0', '< 4.0')
end
