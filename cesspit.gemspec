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
end