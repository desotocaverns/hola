require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "getting edit results in redirect if not autocratic admin" do
    create_admins
    sign_in(@admin)

    get :edit
    assert_redirected_to sales_path, {'message' => 'You are not authorized'}
  end

  test "trying to update with empty tax results in failure" do
    create_admins
    sign_in(@autocratic_admin)

    patch :update, {"settings"=>{"tax"=>"", "company_email"=>"support@desotocaverns.com"}}
    assert_redirected_to settings_path, {'message' => 'Your settings could not be saved because they were invalid'}
  end
end
