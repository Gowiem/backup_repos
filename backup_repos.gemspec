# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backup_repos/version'

Gem::Specification.new do |spec|
  spec.name          = "backup_repos"
  spec.version       = BackupRepos::VERSION
  spec.authors       = ["Gowiem"]
  spec.email         = ["gowie.matt@gmail.com"]

  spec.summary       = %q{For backing up a Github Organization}
  spec.description   = %q{Clones all organization repos, zips them up, and writes them to /tmp/}
  spec.homepage      = "http://useartisan.com"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["backup_repos"]
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
