# https://github.com/ActiveCampaign/postmark-gem/blob/main/lib/postmark/api_client.rb

module Effective
  class PostmarkApi
    attr_accessor :client

    def initialize(api_token:)
      raise('expected an api token') unless api_token.present?
      @client = ::Postmark::ApiClient.new(api_token)
    end

    # EffectivePostmark.api.reactivate(email)
    def reactivate(user)
      raise('expected an effective_postmark_user') unless user.class.try(:effective_postmark_user?)

      # Emails to reactivate
      emails = [user.email, user.try(:alternate_email).presence].compact

      # There are multiple streams. outbound / broadcast / inbound
      begin
        client.delete_suppressions(:outbound, emails)
        client.delete_suppressions(:broadcast, emails)
        true
      rescue => e
        false
      end
    end

  end
end
