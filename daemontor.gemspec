# -*- encoding: utf-8 -*-
require File.expand_path('../lib/daemontor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Wanek"]
  gem.email         = ["dan.wanek@gmail.com"]
  gem.description   = %q{Module to aid in running background processes.}
  gem.summary       = %q{If you are looking for a gem that allows you to simply run a process in the background, Deamontor can help you out. If you're looking for a package that does threading and fine grain process control you'll probably want to look elsewhere.}
  gem.homepage      = "http://github.com/zenchild/daemontor"

  gem.files         = `git ls-files`.split($\)
  gem.extra_rdoc_files = %w(README.md)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "daemontor"
  gem.require_paths = ["lib"]
  gem.version       = Daemontor::VERSION
end
