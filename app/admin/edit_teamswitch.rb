ActiveAdmin.register_page "Edit Team Switch Form" do
  content do
    render "admin/edit_teamswitch"
  end

  page_action :update, method: :post do
    FormField.find(1).update(data: params[:field1])
    FormField.find(2).update(data: params[:field2])
    FormField.find(3).update(data: params[:field3])
    FormField.find(4).update(data: params[:field4])
    FormField.find(5).update(data: params[:field5])
    FormField.find(6).update(data: params[:field6])
    FormField.find(7).update(data: params[:field7])
    FormField.find(8).update(data: params[:field8])
    FormField.find(9).update(data: params[:field9])
    FormField.find(10).update(data: params[:field10])
    FormField.find(11).update(data: params[:field11])
    FormField.find(12).update(data: params[:field12])
    FormField.find(13).update(data: params[:field13])
    FormField.find(14).update(data: params[:field14])
    FormField.find(15).update(data: params[:field15])
    FormField.find(16).update(data: params[:field16])
    FormField.find(17).update(data: Time.now.strftime("%c"))
    redirect_to admin_edit_team_switch_form_path, notice: "Successfully saved changes"
  end
end
