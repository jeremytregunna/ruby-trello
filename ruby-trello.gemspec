Gem::Specification.new do |s|
  s.name = %q{ruby-trello}
  s.version = "0.1.0"
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Jeremy Tregunna"]
  s.date = %q{2012-01-07}
  s.description = %q{A wrapper around the trello.com API.}
  s.email = %q{jeremy@tregunna.ca}
  s.extra_rdoc_files = ["README.md"]
  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.homepage = %q{https://github.com/jeremytregunna/ruby-trello}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-trello}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A wrapper around the trello.com API.}
  s.test_files = Dir.glob("spec/**/*")

  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency 'yajl-ruby', '>= 1.1.0'
  s.add_dependency 'oauth', '~> 0.4.5'
  s.add_dependency 'addressable', '~> 2.2.6'
  s.add_development_dependency 'bundler', '~> 1.0.0'
end
