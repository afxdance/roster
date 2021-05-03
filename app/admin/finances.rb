ActiveAdmin.register Dancer, as: "Finances" do
  if Dancer.table_exists?
    columns = Dancer.columns.map(&:name).map(&:to_sym)
    permit_params columns
  end

  # Scope buttons to filter dancers that have paid dues/bought tickets
  scope :all, default: true
  scope("Paid Dues") { |scope| scope.where("has_paid_dues LIKE ?", "%yes%") }
  scope("Bought Tickets") { |scope| scope.where("has_bought_tickets LIKE ?", "%yes%") }

  member_action :paid_dues, method: :post do
    dancer_id = params[:id]
    dancer_has_paid_dues(dancer_id)
  end

  member_action :bought_tickets, method: :post do
    dancer_id = params[:id]
    dancer_has_bought_tickets(dancer_id)
  end

  member_action :unpay_dues, method: :post do
    dancer_id = params[:id]
    dancer_unpay_dues(dancer_id)
  end

  member_action :unbuy_tickets, method: :post do
    dancer_id = params[:id]
    dancer_unbuy_tickets(dancer_id)
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

    # Modifying certain dancer fields, also tracks when modified and modified by who
    def dancer_has_paid_dues(dancer_id)
      dancer = Dancer.find(dancer_id)
      dancer.has_paid_dues = "yes"
      dancer.dues_changed_at = Time.now
      dancer.dues_approved_by = current_user.username
      dancer.save
      redirect_to :back, alert: "#{dancer.name} has paid their dues."
    end

    def dancer_has_bought_tickets(dancer_id)
      dancer = Dancer.find(dancer_id)
      dancer.has_bought_tickets = "yes"
      dancer.tickets_changed_at = Time.now
      dancer.tickets_approved_by = current_user.username
      dancer.save
      redirect_to :back, alert: "#{dancer.name} has bought their tickets."
    end

    def dancer_unpay_dues(dancer_id)
      dancer = Dancer.find(dancer_id)
      dancer.has_paid_dues = "no"
      dancer.dues_changed_at = Time.now
      dancer.dues_approved_by = current_user.username
      dancer.save
      redirect_to :back, alert: "#{dancer.name} has not paid their dues"
    end

    def dancer_unbuy_tickets(dancer_id)
      dancer = Dancer.find(dancer_id)
      dancer.has_bought_tickets = "no"
      dancer.tickets_changed_at = Time.now
      dancer.tickets_approved_by = current_user.username
      dancer.save
      redirect_to :back, alert: "#{dancer.name} has not bought their tickets"
    end
  end

  index do
    para "<style>td {white-space: nowrap</style>".html_safe

    # Columns from the Dancer table that should be shown in the finance page
    show_fields = [
      :name,
      :has_paid_dues,
      :has_bought_tickets,
      :dues_changed_at,
      :dues_approved_by,
      :tickets_changed_at,
      :tickets_approved_by,
    ]

    # The column name for each field on the page is the same as the column name from the Dancers table except for dues and tickets because the table was getting too fat
    show_fields.each do |field|
      if field == :has_paid_dues
        column("Dues", sortable: :has_paid_dues, &:has_paid_dues)
      elsif field == :has_bought_tickets
        column("Tickets", sortable: :has_bought_tickets, &:has_bought_tickets)
      else
        column field
      end
    end

    # Create column for editing dues
    column :edit_dues do |dancer|
      if dancer.has_paid_dues == "yes"
        content_tag :div do
          link_to("finances/#{dancer.id}/unpay_dues?", method: :post) do
            "+ Undo"
          end
        end
      else
        content_tag :div do
          link_to("finances/#{dancer.id}/paid_dues?", method: :post) do
            "+ Paid Dues"
          end
        end
      end
    end

    # Create column for editing tickets
    column :edit_tickets do |dancer|
      if dancer.has_bought_tickets == "yes"
        content_tag :div do
          link_to("finances/#{dancer.id}/unbuy_tickets?", method: :post) do
            "+ Undo"
          end
        end
      else
        content_tag :div do
          link_to("finances/#{dancer.id}/bought_tickets?", method: :post) do
            "+ Bought Tickets"
          end
        end
      end
    end

    actions
  end
end
