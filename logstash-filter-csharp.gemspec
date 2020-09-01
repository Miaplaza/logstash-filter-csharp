Gem::Specification.new do |s|
  s.name = 'logstash-filter-csharp'
  s.version = '0.2.0'
  s.licenses = ['Apache-2.0']
  s.summary = 'This filter parses C# stack traces and exception messages.'
  s.description = 'This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install logstash-filter-csharp. This gem is not a stand-alone program.'
  s.authors = ['Julian Rüth', 'Solomiia Demkiv']
  s.email = 'infrastructure@miaplaza.com'
  s.homepage = 'https://github.com/Miaplaza/logstash-filter-csharp'
  s.require_paths = ['lib']

  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','Gemfile','LICENSE','NOTICE.TXT']
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'filter' }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', '>= 1.60', '< 3.0'
  s.add_runtime_dependency 'json', '>=2.3.0', '< 3.0.0'
  s.add_development_dependency "logstash-devutils"
end
