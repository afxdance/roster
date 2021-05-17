ActiveAdmin.register_page "Edit Team Switch Form" do
  content do
    render "admin/edit_teamswitch"
  end

  page_action :update, method: :post do
    formfields = []
    for i in 1..16
        formfields << params[i.to_s]
    end
    notice = FormField.setTeamSwitchFields(formfields)
    redirect_to admin_edit_team_switch_form_path, notice: notice
  end

  page_action :set, method: :post do
    formfields = []
    for i in 1..16
        formfields << params[i.to_s]
    end
    FormField.setTeamSwitchFields(formfields)
    notice = FormField.setTeamSwitchBackup
    redirect_to admin_edit_team_switch_form_path, notice: notice
  end

  page_action :revert, method: :post do
    notice = FormField.revertTeamSwitchBackup
    redirect_to admin_edit_team_switch_form_path, notice: notice
  end
end
