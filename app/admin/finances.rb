ActiveAdmin.register Finance do
  if Finance.table_exists?
    columns = Finance.columns.map(&:name).map(&:to_sym)
    permit_params columns
  end

  # Scope buttons to filter dancers that have paid dues/bought tickets
  scope :all, default: true
  scope("Hasn't Paid Dues") { |scope| scope.where(dues: [false, nil]) }
  scope("Hasn't Bought Tickets") { |scope| scope.where(tickets: [false, nil]) }

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
      dancer_finance = Finance.find(dancer_id)
      dancer_finance.dues = true
      dancer_finance.dues_approved = current_user.username
      dancer_finance.dues_updated = Time.now
      dancer_finance.save
      redirect_to :back, alert: "#{dancer_finance.dancer.name} has paid their dues."
    end

    def dancer_has_bought_tickets(dancer_id)
      dancer_finance = Finance.find(dancer_id)
      dancer_finance.tickets = true
      dancer_finance.tickets_approved = current_user.username
      dancer_finance.tickets_updated = Time.now
      dancer_finance.save
      redirect_to :back, alert: "#{dancer_finance.dancer.name} has bought their tickets."
    end

    def dancer_unpay_dues(dancer_id)
      dancer_finance = Finance.find(dancer_id)
      dancer_finance.dues = false
      dancer_finance.dues_approved = current_user.username
      dancer_finance.dues_updated = Time.now
      dancer_finance.save
      redirect_to :back, alert: "#{dancer_finance.dancer.name} has not paid their dues"
    end

    def dancer_unbuy_tickets(dancer_id)
      dancer_finance = Finance.find(dancer_id)
      dancer_finance.tickets = false
      dancer_finance.tickets_approved = current_user.username
      dancer_finance.dues_updated = Time.now
      dancer_finance.save
      redirect_to :back, alert: "#{dancer_finance.dancer.name} has not bought their tickets"
    end
  end

  controller do
    def update
      puts "-----------------------------------------------"
      puts permitted_params[:finance]
      puts params
      finance = Finance.find_by(permitted_params[:id])
      if permitted_params[:finance][:dues]
        finance.update(dues: permitted_params[:finance][:dues])
      elsif permitted_params[:finance][:tickets]
        finance.update(tickets: permitted_params[:tickets])
      end
      redirect_to :back, alert: "Updated"
    end
  end

  index do
    # Columns from the Dancer table that should be shown in the finance page
    show_fields = [
      :dancer_id,
      :name,
      :dues,
      :tickets,
      :dues_approved,
      :tickets_approved,
      :dues_updated,
      :tickets_updated,
    ]

    # Display columns and change dancer id to #
    show_fields.each do |field|
      if field == :dancer_id
        column("#", sortable: :dancer_id) { |finance| "##{finance.dancer_id}" }
      elsif field == :name
        # If the field is the name, get the name corresponding to the dancer ID
        column :name do |finance|
          columns(finance.dancer.name)
        end
      elsif [:tickets, :dues].include?(field)
        # Make the dues and tickets fields toggleable
        column field do |finance|
          if field == :dues && finance.dues == true
            text = "Yes"
            method = "unpay_dues?"
          elsif field == :dues && finance.dues == false
            text = "No"
            method = "paid_dues?"
          elsif field == :tickets && finance.tickets == true
            text = "Yes"
            method = "unbuy_tickets?"
          else
            text = "No"
            method = "bought_tickets?"
          end
          content_tag :div do
            link_to("finances/#{finance.id}/#{method}", method: :post) do
              text
            end
          end
        end
      else
        column field
      end
    end

    actions
  end
end
