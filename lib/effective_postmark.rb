require 'effective_resources'
require 'effective_postmark/engine'
require 'effective_postmark/version'

module EffectivePostmark

  def self.config_keys
    [:layout]
  end

  include EffectiveGem

end
