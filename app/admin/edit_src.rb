ActiveAdmin.register_page "Edit SRC" do

  menu if: proc { current_user.admin? }

  content do
    render partial: "admin/edit_src"
  end

  page_action :update, method: :post do
    formfields = []
    for i in 1..2  # Just trying to make the title editable for now
      formfields << params[i.to_s]
    end
    notice = SrcFormField.update_src_fields(formfields)
    redirect_to admin_edit_src_path, notice: notice
  end

  page_action :set, method: :post do
    formfields = []
    for i in 1..2  # Just trying to make the title editable for now
      formfields << params[i.to_s]
    end
    SrcFormField.update_src_fields(formfields)
    notice = SrcFormField.update_src_backup
    redirect_to admin_edit_src_path, notice: notice
  end
end
