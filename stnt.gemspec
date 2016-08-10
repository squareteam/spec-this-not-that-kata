Gem::Specification.new do |gem|
  gem.name        = 'stnt'
  gem.version     = '0.0.0.kata'
  gem.licenses    = ['MIT']
  gem.authors     = ["Charly Poly", "Paul Bonaud"]
  gem.files       = Dir["lib/**/*.rb"]
  gem.executables = ['stnt']
  gem.summary     = <<-SUMMARY
    This gem is a rewrite inspired by the ttnt gem for Rspec.
  SUMMARY

  gem.add_runtime_dependency "rspec"

  gem.add_development_dependency "sinatra"
  gem.add_development_dependency "rack"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rack-test"
end
