# https://github.com/ActiveCampaign/postmark-gem/blob/main/lib/postmark/api_client.rb

module Effective
  class PostmarkApi
    attr_accessor :client

    def initialize(api_token:)
      raise('expected an api token') unless api_token.present?
      @client = ::Postmark::ApiClient.new(api_token)
    end

    # [ "outbound", "broadcast-stream" ]
    def streams()
      @streams ||= begin
        client.get_message_streams
          .select { |stream| ['Broadcasts', 'Transactional'].include?(stream[:message_stream_type]) }
          .map { |stream| stream[:id] }
      end
    end

    def suppressions()
      streams()
        .flat_map { |stream| client.dump_suppressions(stream) }
        .uniq { |suppression| suppression[:email_address] }
    end

    # Called by rake effective_postmark:assign_email_delivery_errors
    def assign_email_delivery_errors!(users)
      raise('expected an effective_postmark_user klass') unless users.try(:effective_postmark_user?)

      suppressions().each do |suppression|
        email = suppression[:email_address].to_s.downcase.strip
        next unless email.present?

        user = users.find_for_database_authentication(email: email)
        next unless user.present?

        user.postmark_suppression!(reason: suppression[:suppression_reason], date: suppression[:created_at])
      end

      true
    end

    # EffectivePostmark.api.reactivate(email)
    def reactivate(user)
      raise('expected an effective_postmark_user') unless user.class.try(:effective_postmark_user?)

      # Emails to reactivate
      emails = [user.email, user.try(:alternate_email).presence].compact

      # There are multiple streams. outbound / broadcast / inbound
      begin
        streams().each { |stream| client.delete_suppressions(stream, emails) }
        true
      rescue => e
        false
      end
    end

  end
end
