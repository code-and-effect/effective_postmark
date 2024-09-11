module Admin
  class PostmarkController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_postmark) }

    include Effective::CrudController

    resource_scope -> { current_user.class.all }

    on :postmark_reactivate, success: -> { "Successfully reactivated and sent an email to #{resource.email}" }

    def permitted_params
      params.require(:user).permit!
    end

  end
end
