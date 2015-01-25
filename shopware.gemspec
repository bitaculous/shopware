#!/usr/bin/env gem build

lib = File.expand_path '../lib', __FILE__
$:.unshift lib unless $:.include? lib

require 'shopware/version'

Gem::Specification.new 'shopware', Shopware::VERSION do |spec|
  spec.summary          = 'A Ruby client for the Shopware API.'
  spec.author           = 'Maik Kempe'
  spec.email            = 'mkempe@bitaculous.com'
  spec.homepage         = 'https://bitaculous.github.io/shopware/'
  spec.license          = 'MIT'
  spec.files            = Dir['{bin,lib}/**/*', '.shopware.sample', 'LICENSE', 'README.md']
  spec.executables      = ['shopware']
  spec.extra_rdoc_files = ['LICENSE', 'README.md']

  spec.required_ruby_version     = '~> 2.1'
  spec.required_rubygems_version = '~> 2.4'

  spec.add_runtime_dependency 'thor',           '~> 0.19.1'
  spec.add_runtime_dependency 'httparty',       '~> 0.13.3'
  spec.add_runtime_dependency 'valid',          '~> 0.4.0'
  spec.add_runtime_dependency 'terminal-table', '~> 1.4.5'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake',    '~> 10.4.2'
  spec.add_development_dependency 'rspec',   '~> 3.1.0'
end