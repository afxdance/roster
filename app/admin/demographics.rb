ActiveAdmin.register_page "Demographics" do
  menu label: "Demographics", parent: :dancers

  menu if: proc { current_user.admin? }
  content do
    render "admin/demographics"
  end
end
