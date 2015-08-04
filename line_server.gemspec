Gem::Specification.new do |s|
  s.name        = 'line-server'
  s.version     = '0.0.1'
  s.date        = '2015-08-03'
  s.summary     = 'serves one line of a file'
  s.description = 'serves one line of a provided file in response to an http req'
  s.authors     = ['Stuart Terrett']
  s.email       = 'shterrett@gmail.com'
  s.files       = ['lib/line_server.rb']
  s.homepage    = 'http://github.com/shterrett/line-server'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency('sinatra')
  s.add_dependency('thin')

  s.add_development_dependency('rake', '~> 10.4')
  s.add_development_dependency('rspec', '~> 3.3')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('simplecov', '~> 0.10')
  s.add_development_dependency('pry', '~> 0.10')
end
