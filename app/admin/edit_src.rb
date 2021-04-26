ActiveAdmin.register_page "Edit SRC" do

  menu if: proc { current_user.admin? }

  content do
    render "admin/edit_src"
  end

  # Responsible for saving the fields in the database
  page_action :update, method: :post do
    formfields = []
    for i in 1..28  # Just trying to make the title editable for now
      formfields << params[i.to_s] # << is the append operator
    end
    notice = SrcFormField.update_src_form_fields(formfields)
    redirect_to admin_edit_src_path, notice: notice
  end

  # Handles functionality for saving the current fields and setting as backup
  page_action :set, method: :post do
    formfields = []
    for i in 1..28 # Just trying to make the title editable for now
      formfields << params[i.to_s]
    end
    SrcFormField.update_src_form_fields(formfields)
    notice = SrcFormField.update_src_backup
    redirect_to admin_edit_src_path, notice: notice
  end

  # Responsible for reverting database fields to backup
  page_action :revert, method: :post do
    notice = SrcFormField.revert_src_backup
    redirect_to admin_edit_src_path, notice: notice
  end
end
