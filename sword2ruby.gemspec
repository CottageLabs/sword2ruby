# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sword2ruby/version"

Gem::Specification.new do |s|
  s.name        = "sword2ruby"
  s.version     = Sword2Ruby::VERSION
  s.authors     = ["Mark MacGillivray, Martyn Whitwell"]
  s.email       = ["martyn@cottagelabs.com"]
  s.homepage    = "https://github.com/CottageLabs/sword2ruby"
  s.summary     = %q{Provides SWORD client functionality as per the SWORD 2.0 spec when run against a SWORD 2.0 compliant server.}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "sword2ruby"

  # The files included in the gem.
  s.files         = `git ls-files`.split("\n")

  # Files that are used for testing the gem. 
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  
  #Development Dependencies
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.8"

  
  #Runtime Dependencies
  s.add_runtime_dependency "atom-tools", "~> 2.0.5"
  s.add_runtime_dependency "hpricot", "~> 0.8.3"
  
end
