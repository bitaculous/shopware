#!/usr/bin/env gem build

lib = File.expand_path '../lib', __FILE__
$:.unshift lib unless $:.include? lib

require 'shopware/version'

Gem::Specification.new do |spec|
  spec.name          = 'shopware'
  spec.summary       = 'A Ruby client for the Shopware API.'
  spec.author        = 'Maik Kempe'
  spec.email         = 'mkempe@bitaculous.com'
  spec.homepage      = 'http://bitaculous.github.io/shopware'
  spec.version       = Shopware::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.licenses      = 'MIT'

  spec.files         = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(/^bin/).map { |file| File.basename file }
  spec.test_files    = spec.files.grep(/^(features|spec|test)/)

  spec.required_ruby_version = '>= 2.0.0'

  spec.required_rubygems_version = Gem::Requirement.new '>= 2.0.0'

  spec.add_dependency 'thor', '~> 0.19.1'

  spec.add_dependency 'httparty', '~> 0.13.1'

  spec.add_dependency 'valid', '~> 0.4.0'

  spec.add_dependency 'terminal-table', '~> 1.4.5'

  spec.add_development_dependency 'bundler', '~> 1.6.2'

  spec.add_development_dependency 'rake', '~> 10.3.2'

  spec.add_development_dependency 'rspec', '~> 2.14.1'
end