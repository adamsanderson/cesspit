require_relative './lib/version'

Gem::Specification.new do |s|
  s.name        = 'cesspit'
  s.version     = Cesspit::VERSION
  s.authors     = ['Adam Sanderson']
  s.email       = ['netghost@gmail.com']
  s.homepage    = 'https://github.com/adamsanderson/cesspit'
  
  s.summary     = 'Clean up your stinking CeSSPit (see that\'s a joke there).'
  s.description = 'Scans and finds unused css declarations.'
  s.licenses    = 'MIT'

  s.files        = Dir.glob('{bin,lib}/**/*') + ["README.markdown"]
  s.executable   = 'cesspit'
  s.require_path = 'lib'
  
  s.add_runtime_dependency "nokogiri", "1.5.0", "~> 1.6.0"
  s.add_runtime_dependency "css_parser", "~> 1.2.6", "~> 1.3"
end