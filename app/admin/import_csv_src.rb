ActiveAdmin.register_page "Import SRC from CSV" do
  menu label: "Import SRC from CSV", parent: :dancers

  # https://activeadmin.info/10-custom-pages.html
  page_action :update, method: :post do
    csv = CSV.read(params[:csv][:uploaded_file].tempfile, headers: true, encoding: "bom|utf-8")
    errors = []
    ActiveRecord::Base.transaction do
      csv.each do |row|
      email = row[0]
      for dancer in Dancer.all  #@dancers = Dancer.all
        if email == dancer.email
          dancer.update(src_submitted: true)
        end
      end
      end
      if !errors.empty?
        redirect_to admin_import_src_from_csv_path, notice: "There are #{errors.length} invalid src : \n #{errors}"
        raise ActiveRecord::Rollback
      else
        redirect_to admin_import_src_from_csv_path, notice: "Successfully imported src csv"
      end
    end
  end

  content do
    form_for :csv, url: { action: "update" }, html: { multipart: true } do |f|
      f.file_field :uploaded_file
      f.submit "Submit"
    end
  end
end
