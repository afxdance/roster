ActiveAdmin.register_page "Edit SRC" do

  menu if: proc { current_user.admin? }

  content do
    render "admin/edit_src"
  end

  page_action :update, method: :post do
    formfields = []
    puts "PUTS PUTS PUTS"
    # puts params[1.to_s]
    # puts "END PUTS PUTS PUTS"
    for i in 1..2  # Just trying to make the title editable for now
      formfields << params[i.to_s] # << is the append operator
    end
    # puts "var formfields start"
    # puts formfields
    # puts "var formfields end"
    notice = SrcFormField.update_src_form_fields(formfields)
    redirect_to admin_edit_src_path, notice: notice
  end

  page_action :set, method: :post do
    puts "PUTS PUTS PUTS SET"
    formfields = []
    for i in 1..2  # Just trying to make the title editable for now
      formfields << params[i.to_s]
    end
    SrcFormField.update_src_fields(formfields)
    notice = SrcFormField.update_src_backup
    redirect_to admin_edit_src_path, notice: notice
  end
end
