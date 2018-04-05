
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memoized_on_frozen/version'

Gem::Specification.new do |spec|
  spec.name          = 'memoized_on_frozen'
  spec.version       = MemoizedOnFrozen::VERSION
  spec.authors       = ['Ilya Bylich']
  spec.email         = ['ibylich@gmail.com']

  spec.summary       = 'A tiny gem for memoization on frozen objects'
  spec.description   = 'Because memoization creates an ivar'
  spec.homepage      = 'https://github.com/iliabylich/memoized_on_frozen'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
