require 'effective_resources'
require 'effective_logging'
require 'effective_postmark/engine'
require 'effective_postmark/version'

module EffectivePostmark

  def self.config_keys
    [
      :mailer, :parent_mailer, :deliver_method, :mailer_layout, :mailer_sender, :mailer_admin, :mailer_subject,
      :layout, :api_token
    ]
  end

  include EffectiveGem

  def self.api
    Effective::PostmarkApi.new(api_token: api_token)
  end

  def self.mailer_class
    mailer&.constantize || Effective::PostmarkMailer
  end

end
