class DancerController < ApplicationController
  def find_team
    email = params[:email]
    puts(email)
    teams = if Dancer.exists?(email: email)
              Dancer.find_by(email: email).teams.map(&:name)
            else
              teams = "Dancer not found"
    end
    render json: teams.to_json
  end
end
