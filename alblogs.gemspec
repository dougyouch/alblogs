# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'alblogs'
  s.version     = '0.1.2'
  s.summary     = 'ALB access log processing'
  s.description = 'Utility script for processing ALB access logs over a given time range'
  s.authors     = ['Doug Youch']
  s.email       = 'dougyouch@gmail.com'
  s.homepage    = 'https://github.com/dougyouch/alblogs'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir      = 'bin'
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
end
