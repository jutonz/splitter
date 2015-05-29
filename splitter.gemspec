# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','splitter','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'cuesplit'
  s.version = Splitter::VERSION
  s.author = 'Justin Toniazzo'
  s.email = 'jutonz42@gmail.com'
  s.homepage = 'https://github.com/jutonz/splitter'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Splits mp3\'s using cuesheets'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'splitter'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.13.1')
end
