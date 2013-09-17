# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = 'dev-vm-builder'
  gem.version       = '0.0.1'
  gem.authors       = ['Myles Megyesi', 'Steve Kim']
  gem.email         = ['myles.megyesi@gmail.com', 'skim.la@gmail.com']
  gem.description   = 'A wrapper around Packer to build a development vm'
  gem.summary       = 'A wrapper around Packer to build a development vm'

  gem.files         += Dir['lib/**/*.rb']
  gem.files         += Dir['bin/**/*']
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'thor', '~> 0.18.1'
end
