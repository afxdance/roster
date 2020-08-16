class DancerController < ApplicationController
  def get_team
    email = params[:email]
    puts(email)
    if Dancer.exists?(email: email)
      teams = Dancer.find_by(email: email).teams.map(&:name)
    else
      teams = "Dancer not found"
    end
    render json: teams.to_json
  end
end
