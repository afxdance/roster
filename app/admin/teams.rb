ActiveAdmin.register Team do

    permit_params :project, :name, :admin_user_id, :maximum_picks, :timestring, admin_user_ids: [], dancer_ids: []

    member_action :toggle_lock, :method => :post do
        current_team = Team.find(params[:id])
        if current_admin_user.team == current_team || current_admin_user.admin_type == "admin"
          if !current_team.conflicted_dancers?
                current_team.toggle_lock
                current_team.save
                if current_team.locked
                    redirect_to "/admin/teams/#{params[:id]}", :alert => "#{current_team.name} has been locked"
                else
                    redirect_to "/admin/teams/#{params[:id]}", :alert => "#{current_team.name} has been unlocked"
                end
          else
                redirect_to "/admin/teams/#{params[:id]}", :alert => "Unable to lock #{current_team.name}.
                There are dancer conflicts"
          end
        else
            redirect_to "/admin/teams/#{params[:id]}", :alert => "You do not have ownership of #{current_team.name}"
        end
    end

    collection_action :roster_csv, :method => :get do
        current_team = Team.find(params[:id])
        csv = CSV.generate( encoding: "Windows-1251" ) do |csv|
            # Header
            csv << [ "Casting Number", "Name", "Phone Number", "Email", "Gender", "Year", "Casting Group",
                     "Team Offers"]
            # Data
            current_team.dancers.each do |dancer|
                if dancer.casting_group
                    casting_id = dancer.casting_group.id
                else
                    casting_id = nil
                end
                csv << [dancer.id, dancer.name, dancer.phone, dancer.email, dancer.gender, dancer.year, casting_id,
                        dancer.teams.each.collect { |item| item.name }.join(", ")]
            end
        end
        send_data csv.encode("Windows-1251"), type: "text/csv; charset=windows-1251; header=present",
                                              disposition: "attachment; filename=#{current_team.name}_roster.csv"
      # redirect_to "/admin/teams/#{params[:id]}"
    end

    # See permitted parameters documentation:
    # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
    #
    # permit_params :list, :of, :attributes, :on, :model
    #
    # or
    #
    # permit_params do
    #   permitted = [:permitted, :attributes]
    #   permitted << :other if resource.something?
    #   permitted
    # end

    show do |user|
        list = []
        Team.find(params[:id]).dancers.all.each do |dancer|
            list << dancer
        end

        panel "Details" do
            attributes_table_for user do
                current_team = Team.find(params[:id])
                row :team_level do
                    if current_team.project
                        "Project Team"
                    else
                        "Training Team"
                    end
                end
                row :locked do
                    current_team.locked
                end
                row :toggle_lock do
                    link_to "Toggle Team Lock", "/admin/teams/#{params[:id]}/toggle_lock" , method: :post
                end
                row :team_size do
                    current_team.dancers.all.length
                end
                row :gender_ratio do
                    male = 0
                    female = 0
                    current_team.dancers.each do |dancer|
                        if dancer.gender == "Male" || dancer.gender == "M"
                          male += 1
                        else
                          female += 1
                        end
                    end
                    "Males: #{male} / Females: #{female}"
                end
                row :csv do
                    link_to "Print CSV for #{current_team.name}", params.merge(:action => :roster_csv)
                end
                row :maximum_picks do
                    current_team.maximum_picks
                end
                row :timestring do
                    current_team.timestring
                end
            end
        end

        panel "Director/s" do
            current_team = Team.find(params[:id])
            attributes_table_for user do
                current_team.admin_users.each do |admin|
                    row admin.email do
                        admin.names
                    end
                end
            end
        end

        panel "Dancers" do
            table_for user.dancers do
                column :name do |dancer|
                    link_to dancer.name, admin_dancer_path(dancer), method: :get
                end
                column :time_conflict do |dancer|
                    if dancer.unavailable_for? user
                        link_to "Time conflict!", admin_dancer_path(dancer), method: :get
                    else
                        ""
                    end
                end
                column :phone
                column :email
            end
        end

        active_admin_comments
    end

    index do
        selectable_column
        column :name
        column :directors do |team|
            wauw = ""
            team.admin_users.each do |a|
              if !a.names.nil?
                wauw << a.names
              end
            end
            wauw
        end
        column :timestring
        column :size do |team|
            team.dancers.length
        end
        column :project
        column :locked
        actions
    end

    form do |f|
        f.inputs do
            f.input :admin_users, member_label: proc { |c| "#{c.email}" }
            f.input :project
            f.input :name
            f.input :maximum_picks
            f.input :timestring
        end
        f.actions
    end

    csv do
        column(:team) { |team| team.name }
        column(:dancers) { |team| team.dancers.collect(&:name).join(", ") }
    end

    filter :name
    filter :locked
    config.per_page = 15
end
