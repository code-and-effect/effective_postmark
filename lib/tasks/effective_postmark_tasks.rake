namespace :effective_postmark do
  desc 'Assign email delivery errors to postmark users from suppressions API'
  task assign_email_delivery_errors: :environment do
    table = ActiveRecord::Base.connection.table_exists?(:users)
    blank_tenant = defined?(Tenant) && Tenant.current.blank?

    if table && !blank_tenant && EffectivePostmark.api_present?
      puts "Assigning postmark email delivery errors"

      klass = User.all
      raise("expected an effective_postmark_user User class") unless klass.try(:effective_postmark_user?)

      api = EffectivePostmark.api

      begin
        api.assign_email_delivery_errors!(klass)
      rescue StandardError => e
        EffectiveResources.send_error(e)
        puts "Error with effective_postmark:assign_email_delivery_errors"
      end
    end

    puts 'All done'
  end
end
