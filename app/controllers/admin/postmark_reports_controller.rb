module Admin
  class PostmarkReportsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_postmark) }

    def inactive_recipients
      @datatable = Admin::ReportInactiveRecipientsDatatable.new
      @page_title = @datatable.datatable_name

      authorize! :index, @datatable

      render 'index'
    end

  end
end
