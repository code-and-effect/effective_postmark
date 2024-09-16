module Admin
  class PostmarkReportsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_postmark) }

    include Effective::CrudController

    def email_delivery_errors
      @datatable = Admin::ReportEmailDeliveryErrorsDatatable.new
      @page_title = @datatable.datatable_name

      authorize! :index, @datatable

      render 'index'
    end

  end
end
