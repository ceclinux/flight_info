lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'httparty'
  spec.add_development_dependency 'activesupport'
  spec.authors = ['Ruochen Shen']
  spec.description = 'Simple wrapper for the flight_info API'
  spec.email = ['src655@gmail.com']
  spec.files = %w[flight_info.gemspec]
  spec.files += Dir.glob('lib/**/*.rb')
  spec.homepage = 'https://github.com/ceclinux/flight_info'
  spec.licenses = ['MIT']
  spec.name = 'flight_info'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = 'Ruby toolkit for querying flight information'
  spec.version = '0.1.1'
end
