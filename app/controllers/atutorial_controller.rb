class AtutorialController < ApplicationController
  def index
    @dancers = Dancer.all
    render "index"
  end

  def new
    alph = ("a".."z").to_a
    name =alph[rand(alph.size)]
    rand(6).times{name += alph[rand(alph.size)].to_s}
    email = name + "@" + name + "." + name
    phone = rand(10 ** 10)
    new_dancer = Dancer.create!(
      name: name,
      email: email,
      phone: phone,
      gender: ".",
      year: ".",
      dance_experience: ".",
      exp_interest: ".",
      tech_interest: ".",
      camp_interest: ".",
      reach_workshop_interest: ".",
      reach_news_interest: ".",
      )
    redirect_back fallback_location: {action: "index"}
  end

  def remove
    Dancer.destroy_all
    redirect_back fallback_location: {action: "index"}
  end

  def create
    create_dancer = Dancer.create!(
      name: params[:dancer][:name],
      email: params[:dancer][:email],
      phone: params[:dancer][:phone],
      gender: ".",
      year: ".",
      dance_experience: ".",
      exp_interest: ".",
      tech_interest: ".",
      camp_interest: ".",
      reach_workshop_interest: ".",
      reach_news_interest: ".",
      )
    redirect_back fallback_location: {action: "index"}
  end
end
