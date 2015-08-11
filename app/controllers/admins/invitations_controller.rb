class Admins::InvitationsController < Devise::InvitationsController
  def after_invite_path_for(resource)
    admins_path
  end
end
