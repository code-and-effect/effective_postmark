module EffectivePostmark
  class Engine < ::Rails::Engine
    engine_name 'effective_postmark'

    # Set up our default configuration options.
    initializer 'effective_postmark.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_postmark.rb")
    end

  end
end
