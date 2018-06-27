ActiveAdmin.register_page "Set Audition Number" do
  menu label: "Set Audition Number", parent: :dancers

  controller do
    before_action :update, only: :index
    def update
      return if params[:nextauditionnumber].nil?

      id = params[:nextauditionnumber].to_i
      begin
        flash.now[:notice] = "You have set the next audition number to #{Dancer.next_id = id}"
      rescue RuntimeError => e
        flash.now[:alert] = e.message
      end
    end
  end

  content do
    form method: :get, url: admin_set_audition_number_path do |f|
      # f.text_field :nextauditionnumber, required: true, placeholder: "Next Audition Number"
      f.input name: :nextauditionnumber, required: true, placeholder: "Next Audition Number"
      f.input :submit, type: :submit, value: "Set"
    end
  end
end
