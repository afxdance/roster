class DancerController < ApplicationController
  def find_team
    email = params[:email]
    teams = if Dancer.exists?(email: email)
      Dancer.find_by(email: email).teams.map(&:name)
    else
      "Dancer not found"
    end
    render json: teams.to_json
  end

  def check_dancer_and_src
    email = params[:email]
    name = params[:name]
    phone = params[:phone]

    dancer = Dancer.where(name: name, email: email, phone: phone)
    src_exists = false # default
    dancer_exists = false
    if dancer.exists?
      dancer_exists = true
      src_exists = dancer.first.src ? true : false
    end

    respond_to do |format| # respond_to
      format.json  { render json: { dancer_exists: dancer_exists, src_exists: src_exists } }
    end
  end
end
