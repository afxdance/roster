ActiveAdmin.register Dancer, :as => 'Finances' do
  if Dancer.table_exists?
    columns = Dancer.columns.map(&:name).map(&:to_sym)
    permit_params columns
  end

  member_action :paid_dues, method: :post do
    dancer_id = params[:id]
    dancer_has_paid_dues(dancer_id)
  end

  member_action :bought_tickets, method: :post do
    dancer_id = params[:id]
    dancer_has_bought_tickets(dancer_id)
  end

  controller do
    def action_methods
      if current_user.can_modify_dancer_fields?
        super
      else
        super - ["edit", "destroy"]
      end
    end

    def back_url
      request.referrer
    end

    def dancer_has_paid_dues(dancer_id)
      dancer = Dancer.find(dancer_id)
      dancer.has_paid_dues = "yes"
      dancer.save
      redirect_to :back, alert: "#{dancer.name} has paid their dues."
    end

    def dancer_has_bought_tickets(dancer_id)
      dancer = Dancer.find(dancer_id)
      dancer.has_bought_tickets = "yes"
      dancer.save
      redirect_to :back, alert: "#{dancer.name} has bought their tickets."
    end
  end

  index do
    para "<style>td {white-space: nowrap</style>".html_safe

    show_fields = [:name, :email, :has_paid_dues, :has_bought_tickets]

    show_fields.each do |field|
      if field == :id
        column("#", sortable: :id) { |dancer| "##{dancer.id}" }
      else
        column field
      end
    end

    column :edit_dues do |dancer|
      next if dancer.has_paid_dues == "yes"

      content_tag :div do
        link_to("finances/#{dancer.id}/paid_dues?", method: :post) do
          "+ Paid Dues"
        end
      end
    end

    column :edit_tickets do |dancer|
      next if dancer.has_bought_tickets == "yes"

      content_tag :div do
        link_to("finances/#{dancer.id}/bought_tickets?", method: :post) do
          "+ Bought Tickets"
        end
      end
    end

    actions
  end
end
