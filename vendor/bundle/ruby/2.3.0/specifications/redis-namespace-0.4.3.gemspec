# -*- encoding: utf-8 -*-
# stub: redis-namespace 0.4.3 ruby lib

Gem::Specification.new do |s|
  s.name = "redis-namespace".freeze
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Wanstrath".freeze]
  s.date = "2010-05-17"
  s.description = "Adds a Redis::Namespace class which can be used to namespace calls\nto Redis. This is useful when using a single instance of Redis with\nmultiple, different applications.\n".freeze
  s.email = "chris@ozmm.org".freeze
  s.homepage = "http://github.com/defunkt/redis-namespace".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Namespaces Redis commands.".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version
end
