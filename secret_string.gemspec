require "#{__dir__}/lib/secret_string/version"

Gem::Specification.new do |s|
  s.name = 'secret_string'
  s.version = SecretString::VERSION
  s.authors = ['Muriel Salvan']
  s.email = ['muriel@x-aeon.com']
  s.license = 'BSD-3-Clause'
  s.summary = 'Secret String'
  s.description = 'Remove secrets (passwords, keys...) from memory'
  s.required_ruby_version = '~> 2.6'

  s.files = Dir['*.md'] + Dir['{bin,docs,examples,lib,spec,tools}/**/*']
  s.executables = Dir['bin/**/*'].map { |exec_name| File.basename(exec_name) }
  s.extra_rdoc_files = Dir['*.md'] + Dir['{docs,examples}/**/*']

  # Dependencies

  # Test framework
  s.add_development_dependency 'rspec', '~> 3.8'
  # Automatic semantic releasing
  s.add_development_dependency 'sem_ver_components', '~> 0.0'
  # Lint checker
  s.add_development_dependency 'rubocop', '~> 1.16'
  # Lint checker for rspec
  s.add_development_dependency 'rubocop-rspec', '~> 2.4'
end
