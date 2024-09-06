module Admin
  class PostmarkController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_postmark) }

    include Effective::CrudController

    if (config = EffectivePostmark.layout)
      layout(config.kind_of?(Hash) ? config[:admin] : config)
    end

    submit :save, 'Save'
    submit :save, 'Save and Add New', redirect: :new

    def email_template_params
      params.require(:effective_email_template).permit!
    end

  end
end
