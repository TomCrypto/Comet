lib = File.expand_path '../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'comet/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Thomas Beneteau']
  gem.email         = ['thomas@bitwise.me']
  gem.description   = 'The no-nonsense build tool for embedded software'
  gem.summary       = 'Comet is a fast and simple LLVM-oriented build tool'
  gem.homepage      = 'https://github.com/TomCrypto/Comet'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['comet']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'comet-build'
  gem.require_paths = ['lib']
  gem.version       = Comet::VERSION

  gem.add_development_dependency 'bundler', '~> 1.7'
  gem.add_development_dependency 'rake', '~> 12.0'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop-rspec'

  gem.add_runtime_dependency 'require_all', '~> 1.5'
  gem.add_runtime_dependency 'slop'
end
