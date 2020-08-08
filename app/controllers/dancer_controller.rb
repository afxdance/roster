class DancerController < ApplicationController
  def getTeam
    email = params[:email]
    puts(email)
    if (Dancer.exists?(email: email))
      teams = Dancer.find_by(email: email).teams.map{ |team| team.name }
    else
      teams = "Dancer not found"
    end
    render json: teams.to_json
  end
end
