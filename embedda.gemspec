# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "embedda"
  gem.version     = '0.0.6'
  gem.authors     = ["Kasper Grubbe",'Christian Takle']
  gem.email       = ["kaspergrubbe@gmail.com"]
  gem.homepage    = "http://github.com/kaspergrubbe/embedda"
  gem.summary     = %q{Embed content strings in your strings, and turn it to embed HTML!}
  gem.description = %q{Embed content strings in your strings, and turn it to embed HTML!}

  gem.licenses = ['MIT', 'GPL-2']

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_runtime_dependency     "rack"
end
