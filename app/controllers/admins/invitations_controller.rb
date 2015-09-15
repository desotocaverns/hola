class Admins::InvitationsController < Devise::InvitationsController
  def after_invite_path_for(resource)
    admins_path
  end

  def create
    super

    if params[:admin][:autocratic] == "yes"
        resource.update_attribute(:autocratic, true)
    end
  end
end
