ActiveAdmin.register_page "Import SRC from CSV" do
  menu label: "Import SRC from CSV", parent: :dancers

  # https://activeadmin.info/10-custom-pages.html
  page_action :update, method: :post do
    csv = CSV.read(params[:csv][:uploaded_file].tempfile, headers: true, encoding: "bom|utf-8")
    errors = []
    ActiveRecord::Base.transaction do
      puts "#{csv}"
      csv.each do |row|
        hash_strings = row.to_hash
        hash_symbols = {}
        for key in hash_strings.keys
          hash_symbols[key.tr(" ", "_").downcase.to_sym] = hash_strings
          puts hash_symbols
          [key]
          #isolate the email (1st column entry)
          #for every email
          #   find the associated dancer
          #   set boolean var to 'true' in Dancer model
        end
        begin
          #
          #
          #Dancer.create!(hash_symbols)
          #
          #
        rescue ActiveRecord::RecordNotUnique
          errors.push(hash_symbols)
        end
      end
      if !errors.empty?
        redirect_to admin_import_src_from_csv_path, notice: "There are #{errors.length} invalid src : \n #{errors}"
        raise ActiveRecord::Rollback
      else
        redirect_to admin_import_src_from_csv_path, notice: "Successfully imported src"
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
