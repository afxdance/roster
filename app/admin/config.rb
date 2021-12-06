# checkmark toggle for each option to toggle (False/True)
# checkmark is set by default to whatever the setting currently is
# button at the bottom called 'Update' that actually sends all updates at once to REDIS

ActiveAdmin.register_page "Config" do
  menu label: "Config", parent: :dancers, if: proc { current_user.admin? }

  page_action :update_preferences, method: :post do
    REDIS.set("Team Switch Form", params.key?("Team Switch Form_cb"))
    REDIS.set("Audition Form", params.key?("Audition Form_cb"))
    # For every interest, set the REDIS entry accordingly based on whether the key is present
    # i.e. whether the box was checked or not.
    Dancer::TOGGLABLE_INTERESTS.each do |interest|
      REDIS.set(interest, params.key?(interest + "_cb"))
    end
    redirect_to admin_config_path(update_preferences_message: "All preferences have been updated")
  end
end
