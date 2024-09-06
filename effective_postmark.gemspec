$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'effective_postmark/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'effective_postmark'
  s.version     = EffectivePostmark::VERSION
  s.authors     = ['Code and Effect']
  s.email       = ['info@codeandeffect.com']
  s.homepage    = 'https://github.com/code-and-effect/effective_postmark'
  s.summary     = 'Effective Postmark captures Postmark::InvalidRecipientError and marks users as bounced'
  s.description = 'Effective Postmark captures Postmark::InvalidRecipientError and marks users as bounced'
  s.licenses    = ['MIT']

  s.files       = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'README.md']

  s.add_dependency 'rails'
  s.add_dependency 'postmark-rails'
  s.add_dependency 'effective_bootstrap'
  s.add_dependency 'effective_datatables', '>= 4.0.0'
  s.add_dependency 'effective_resources'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'effective_test_bot'
  s.add_development_dependency 'effective_developer' # Optional but suggested
  s.add_development_dependency 'psych', '< 4'
end
