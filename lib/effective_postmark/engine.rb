module EffectivePostmark
  class Engine < ::Rails::Engine
    engine_name 'effective_postmark'

    # Set up our default configuration options.
    initializer 'effective_postmark.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_postmark.rb")
    end

    # Include acts_as_addressable concern and allow any ActiveRecord object to call it
    initializer 'effective_postmark.active_record' do |app|
      app.config.to_prepare do
        ActiveRecord::Base.extend(EffectivePostmarkUser::Base)
      end
    end

  end
end
