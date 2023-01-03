# frozen_string_literal: true

require_relative 'lib/athan/version'

Gem::Specification.new do |s|
  s.name        = 'athan'
  s.version     = Athan::VERSION
  s.summary     = 'Athan'
  s.description = ''
  s.authors     = ['Wadii Hajji']
  s.email       = 'hajji.wadii@gmail.com'

  s.add_dependency 'colorize', '~> 0.8.0'
  s.add_dependency 'httparty', '>= 0.18', '< 0.22'
  s.add_dependency 'xdg', '~> 4.5.0'

  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/hwadii/athan'
  s.executables   = ['athan']
  s.require_paths = ['lib']
  s.license = 'MIT'
end
