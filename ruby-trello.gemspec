Gem::Specification.new do |s|
  s.name              = %q{ruby-trello}
  s.version           = "1.2.1"
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
  s.rubyforge_project = %q{ruby-trello}
  s.rubygems_version  = %q{1.3.5}
  s.summary           = %q{A wrapper around the trello.com API.}
  s.test_files        = Dir.glob("spec/**/*")

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'activemodel', '>= 3.2.0'
  s.add_dependency 'addressable', '~> 2.3'
  s.add_dependency 'json'
  s.add_dependency 'oauth',       '~> 0.4.5'
  s.add_dependency 'rest-client', '~> 1.7.2'
end
