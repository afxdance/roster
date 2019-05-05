ActiveAdmin.register FormField do
  actions :all, :except => [:destroy, :new]
  menu if: proc { current_user.admin? }
  before_action :role_check
  permit_params(
    :identity,
    :text,
  )

  controller do
  # checks if user can view the users page
    def role_check
      redirect_to "/admin", alert: "You can't view the form fields page!!! >:( uwu" unless current_user.can_view_form_fields?
    end
  end

  form do |f|
    f.inputs do
    f.input :identity
    f.input :text
    end
    f.actions
  end
end