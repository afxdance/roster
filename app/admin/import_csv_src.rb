require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

# https://gist.github.com/peterclark/df7e68e62cb97385beb46685c66a8606
# https://github.com/googleworkspace/ruby-samples/blob/master/sheets/quickstart/quickstart.rb
scopes =  ['https://www.googleapis.com/auth/spreadsheets']
authorization = Google::Auth.get_application_default(scopes)

auth_client = authorization.dup
auth_client.fetch_access_token!
service = Google::Apis::SheetsV4::SheetsService.new
service.authorization = auth_client

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

  page_action :submiturl, method: :post do
    url_link = params[:urls][:google_form_url]
    spreadsheet_id = url_link.split(/\/(?=[\w])/)[-2]

    range = "Sheet1!A2:A" # Only get email addresses
    response = service.get_spreadsheet_values spreadsheet_id, range

    ActiveRecord::Base.transaction do
      response.values.each do |row|
        for dancer in Dancer.all
          if dancer.email == row[0]
            dancer.update(src_submitted: true)
          end
        end
      end

      redirect_to admin_import_src_from_csv_path, notice: "Successfully updated from Google Sheets"
    end
  end

  content do
    form_for :csv, url: { action: "update" }, html: { multipart: true } do |f|
      f.file_field :uploaded_file
      f.submit "Submit CSV"
    end

    #create a form field
    form_for :urls, url: { action: "submiturl" } do |f|
      f.url_field :google_form_url, placeholder: "Google Sheets URL"
      f.submit "Submit URL"
    end
  end
end
