ActiveAdmin.register_page "Demographics" do
  menu label: "Demographics", parent: :dancers

  content do
    panel "All Dancers" do
    	render partial: 'admin/demographics', locals: {team_id: nil}
    	# pie_chart Dancer.group(:gender).count, title: "Gender", width: "300px", height: "300px"
    	# pie_chart Dancer.group(:year).count, title: "Year", width: "300px", height: "300px"
    end
    panel "Teams" do
    	tabs do
    		for team in Team.all
    			tab team.name do
    				render partial: 'admin/demographics', locals: {team_id: team.id}
    				# pie_chart Dancer.joins("inner join dancers_teams on dancers.id = dancers_teams.dancer_id").where("dancers_teams.team_id = #{team.id}").group(:gender).count, title: "Gender", width: "300px", height: "300px"

    			end
    		end
    	end
    end
  end
end
