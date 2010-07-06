# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bigamy}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Angilly"]
  s.date = %q{2010-07-06}
  s.description = %q{}
  s.email = %q{ryan@angilly.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "bigamy.gemspec",
     "lib/bigamy.rb",
     "lib/bigamy/ar.rb",
     "lib/bigamy/mongo.rb",
     "lib/bigamy/proxy.rb",
     "test/functional/test_helper.rb",
     "test/test_helper.rb",
     "test/unit/test_ar_side.rb",
     "test/unit/test_helper.rb",
     "test/unit/test_mongo_side.rb",
     "test/unit/test_proxy.rb"
  ]
  s.homepage = %q{http://github.com/ryana/bigamy}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Have associations between ActiveRecord objects and MongoMapper documents}
  s.test_files = [
    "test/functional/test_helper.rb",
     "test/test_helper.rb",
     "test/unit/test_ar_side.rb",
     "test/unit/test_helper.rb",
     "test/unit/test_mongo_side.rb",
     "test/unit/test_proxy.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, ["= 2.11.0"])
      s.add_development_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_development_dependency(%q<factory_girl>, ["= 1.3.1"])
      s.add_development_dependency(%q<ruby-debug>, ["= 0.10.3"])
      s.add_development_dependency(%q<mongo_mapper>, ["= 0.8.2"])
      s.add_development_dependency(%q<active_record>, [">= 2.3.5"])
    else
      s.add_dependency(%q<shoulda>, ["= 2.11.0"])
      s.add_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_dependency(%q<factory_girl>, ["= 1.3.1"])
      s.add_dependency(%q<ruby-debug>, ["= 0.10.3"])
      s.add_dependency(%q<mongo_mapper>, ["= 0.8.2"])
      s.add_dependency(%q<active_record>, [">= 2.3.5"])
    end
  else
    s.add_dependency(%q<shoulda>, ["= 2.11.0"])
    s.add_dependency(%q<mocha>, ["= 0.9.8"])
    s.add_dependency(%q<factory_girl>, ["= 1.3.1"])
    s.add_dependency(%q<ruby-debug>, ["= 0.10.3"])
    s.add_dependency(%q<mongo_mapper>, ["= 0.8.2"])
    s.add_dependency(%q<active_record>, [">= 2.3.5"])
  end
end

