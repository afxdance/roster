ActiveAdmin.register_page "Demographics" do
  menu label: "Demographics", parent: :dancers

  content do
    render "admin/demographics"
  end
end
