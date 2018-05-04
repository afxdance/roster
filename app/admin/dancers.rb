ActiveAdmin.register Dancer do

    permit_params(
        :availability,
        :casting_group_id,
        :devinterest,
        :email,
        :gender,
        :name,
        :phone,
        :year,
        casting_group_ids: [],
        team_ids: [],
    )

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

    action_item :wow, only: :index do
        link_to "Final Randomization", "/admin/dancers/final_randomization"
    end

    # action_item :wow, only: :index do
    #     link_to "Import from CSV", "/admin/dancers/import_csv"
    # end

    action_item :wow, only: :index do
        link_to "Next Audition Number", "/admin/dancers/next_audition_number"
    end

    collection_action :final_randomization, method: :get do
        admin_type = current_admin_user.admin_type
        if admin_type != "admin" and admin_type != "board"
            flash[:alert] = "You do not have sufficient permissions to do this!"
        elsif Team.all_teams_done
            Team.final_randomization
            flash[:notice] = "Members randomized between training teams."
        else
            flash[:alert] = "Not all teams are locked! Can't randomize."
        end
        redirect_to "/admin/dancers"
    end

    # collection_action :import_from_csv, method: :get do
    #     redirect_to "/admin"
    # end

    collection_action :next_audition_number, method: :get do
        admin_type = current_admin_user.admin_type
        if admin_type != "admin" and admin_type != "board"
            flash[:alert] = "You do not have sufficient permissions to do this!"
        end
        # Dancer.reset_pk_sequence # resets Dancer ID everytime button clicked
        flash[:notice] = "The next audition number is: #{(Dancer.maximum("id") || 0) + 1}"
        redirect_to "/admin/dancers"
    end

    member_action :add_to_my_team, :method => :post do
        ids = params[:id]
        add_helper(ids, current_admin_user)
    end

    member_action :remove_from_my_team, :method => :post do
        ids = params[:id]
        remove_helper(ids, current_admin_user)
    end

    form do |f|
        f.inputs do
            f.input :availability
            f.input :casting_group, member_label: Proc.new { |c| "#{c.id}" }
            f.input :devinterest
            f.input :email
            f.input :experience
            f.input :gender
            f.input :name
            f.input :phone
            f.input :year
        end
        f.actions
    end

    controller do

        def add_helper(ids, current_admin_user)
            nil_casting_group = []
            Dancer.find(Array(ids)).each do |id|
                if id.casting_group == nil
                    nil_casting_group << id.name
                end
            end

            if current_admin_user.team == nil
                redirect_to '/admin/dancers', :alert => "your account is not associated with a team"
            elsif nil_casting_group.length > 0
                redirect_to '/admin/dancers', :alert => "#{nil_casting_group} is not in a casting group. All dancers must be in a casting group to be added. Please reselect."
            else
                if current_admin_user.team.locked
                    redirect_to '/admin/dancers', :alert => "#{current_admin_user.team.name} is currently locked right now"
                elsif current_admin_user.team.can_pick
                    if current_admin_user.team.can_add(ids.length)
                        added = current_admin_user.team.add_dancers(ids)
                        redirect_to '/admin/dancers', :alert => "#{added} added to #{current_admin_user.team.name}"
                    else
                        redirect_to '/admin/dancers', :alert => "You are over the maximum number of picks you can have"
                    end
                else
                    redirect_to '/admin/dancers', :alert => "You cannot pick right now, project teams are still picking"
                end
            end
        end


        def remove_helper(ids, current_admin_user)
            if current_admin_user.team == nil
                redirect_to '/admin/dancers', :alert => "your account is not associated with a team"
            else
                if current_admin_user.team.locked
                    redirect_to '/admin/dancers', :alert => "#{current_admin_user.team.name} is currently locked right now"
                elsif current_admin_user.team.can_pick
                    removed = current_admin_user.team.remove_dancers(ids)
                    redirect_to '/admin/dancers', :alert => "#{removed} have been deleted from #{current_admin_user.team.name}"
                else
                    redirect_to '/admin/dancers', :alert => "You cannot pick right now, project teams are still picking"
                end
            end
        end
    end



    batch_action :add_to_my_team do |ids|
        add_helper(ids, current_admin_user)
    end

    batch_action :remove_from_my_team do |ids|
        remove_helper(ids, current_admin_user)
    end

    index do
        selectable_column
        column :id
        column :name
        column :team_offers do |dancer|
            dancer.teams.each.collect { |item| item.name }.join(", ")
        end
        column :casting_video do |dancer|
            if dancer.casting_group != nil
                text_node link_to(dancer.casting_group.video, dancer.casting_group.video, method: :get).html_safe
            end
        end
        column :casting_group
        column :conflicted
        column :add_to_my_team do |dancer|
            link_to "Add", "/admin/dancers/#{dancer.id}/add_to_my_team" , method: :post
        end
        column :remove_from_my_team do |dancer|
            link_to "Remove", "/admin/dancers/#{dancer.id}/remove_from_my_team" , method: :post
        end
        actions

    end

    show do |dancer|
        panel "Details" do
            attributes_table_for dancer do
              row :id
              row :name
              row :email
              row :phone
              row :year
              row :gender
              row :experience
              row :availability do |dancer|
                render inline: """
                <ul>
                <% availability = Hash[ @dancer.availability.sort_by { |team_id, available| Team.find(team_id).name } ] %>
                <% for team_id, available in availability %>
                    <% team =  Team.find(team_id) %>
                    <li><%= link_to(team.name, admin_team_path(team), method: :get) %>: <%= available == '0' ? 'No' : 'Yes' %></li>
                <% end %>
                </ul>
                """
              end
              row :devinterest
            end
        end

        panel "Teams" do
            attributes_table_for dancer do
                row :conflicted
                row :team_offers do |dancer|
                    dancer.teams.map do |team|
                        if dancer.unavailable_for?(team)
                            label = "#{team.name} (Time conflict!)"
                        else
                            label = team.name
                        end
                        link_to label, admin_team_path(team), method: :get
                    end.join("<br>").html_safe
                end
            end
        end

        panel "Casting" do
            attributes_table_for dancer do
                row :casting_group
                row :casting_link do |dancer|
                    if dancer.casting_group != nil
                        text_node link_to(dancer.casting_group.video, dancer.casting_group.video, method: :get).html_safe
                    end
                end
                row :casting_video do |dancer|
                    parse = nil
                    if dancer.casting_group != nil
                        regex = /^(?:https?:\/\/)?(?:www\.)?\w*\.\w*\/(?:watch\?v=)?((?:p\/)?[\w\-]+)/
                        parse = dancer.casting_group.video.match(regex)
                    end
                    parse_link = 'Embed Failed'
                    if parse
                      parse_link = parse[1]
                      text_node %{<iframe src="https://www.youtube.com/embed/#{parse_link}" width="640" height="480" scrolling="no" frameborder="no"></iframe>}.html_safe
                    end
                end
            end
        end

    active_admin_comments
  end


    csv do
        column(:casting_number) { |dancer| dancer.id }
        column(:name) { |dancer| dancer.name }
        column(:email) { |dancer| dancer.email }
        column(:phone) { |dancer| dancer.phone }
        column(:year) { |dancer| dancer.year }
        column(:gender) { |dancer| dancer.gender }
        column(:experience) { |dancer| dancer.experience }
        column(:teams) { |dancer| dancer.teams.each.collect { |item| item.name }.join(", ") }

    end

    #scope("Available"){|scope| scope.where(available:true)}
    scope :all, default: true
    scope("Conflicted"){|scope| scope.where(conflicted:true)}

    filter :conflicted, as: :check_boxes
    filter :name
    filter :id
    filter :teams
    filter :devinterest

    config.per_page = 15
end
