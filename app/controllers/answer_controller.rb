class AnswerController < ApplicationController
  def index
    @dancers = Dancer.all
    render "index"
  end

  def new
    source = ("a".."z").to_a + ("A".."Z").to_a
    rand_name = ""
    rand(2..10).times{ rand_name += source[rand(source.size)].to_s }
    rand_email = rand_name + "@berkeley.edu"
    rand_phone = rand(10 ** 10)
    dancer = Dancer.create!(name: rand_name,
      email: rand_email,
      phone: rand_phone,
      gender: 'female',
      year: "3",
      dance_experience: '1',
      exp_interest: "not important rn",
      tech_interest: "not important rn",
      camp_interest: "not important rn",
      reach_workshop_interest: "not important rn",
      reach_news_interest: "not important rn",
    )
    redirect_back fallback_location: { action: "index"}
  end

  def remove
    Dancer.destroy_all
    redirect_back fallback_location: { action: "index"}
  end

  def save
    name = params[:dancer][:name]
    email = params[:dancer][:email]
    phone = params[:dancer][:phone]
    Dancer.create!(name: name,
      email: email,
      phone: phone,
      gender: 'female',
      year: "3",
      dance_experience: '1',
      exp_interest: "not important rn",
      tech_interest: "not important rn",
      camp_interest: "not important rn",
      reach_workshop_interest: "not important rn",
      reach_news_interest: "not important rn",
    )
    redirect_back fallback_location: { action: "index"}
  end
end
