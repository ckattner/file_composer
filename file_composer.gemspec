# frozen_string_literal: true

require './lib/file_composer/version'

Gem::Specification.new do |s|
  s.name        = 'file_composer'
  s.version     = FileComposer::VERSION
  s.summary     = 'High-level, pluggable, and declarative API for creating files'

  s.description = <<-DESCRIPTION
    This library provides a declarative API, called a Blueprint, that allows you to specify text files and zip files and it will create them.  It is pluggable so other document types and storage mediums can be added.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir      = 'exe'
  s.executables = []
  s.homepage    = 'https://github.com/bluemarblepayroll/file_composer'
  s.license     = 'MIT'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/bluemarblepayroll/file_composer/issues',
    'changelog_uri' => 'https://github.com/bluemarblepayroll/file_composer/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/file_composer',
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }

  s.required_ruby_version = '>= 2.5'

  s.add_dependency('acts_as_hashable', '~>1.2')
  s.add_dependency('rubyzip', '~>1.2')

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry', '~>0')
  s.add_development_dependency('rake', '~> 13')
  s.add_development_dependency('rspec', '~> 3.8')
  s.add_development_dependency('rubocop', '~>0.88.0')
  s.add_development_dependency('rubocop-ast', '~>0.3.0')
  s.add_development_dependency('simplecov', '~>0.18.5')
  s.add_development_dependency('simplecov-console', '~>0.7.0')
end
