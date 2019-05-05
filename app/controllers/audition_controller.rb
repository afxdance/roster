class AuditionController < ApplicationController
  def index
    @dancer = Dancer.new
    @descr_email = get_text("email")
    @descr_phone = get_text("phone")
    @descr_gender = get_text("gender")
    @descr_expinterest = get_text("expinterest")
    @descr_techinterest = get_text("techinterest")
  end

  def create
    @dancer = Dancer.new(dancer_params)
    success = @dancer.save
    @descr_email = get_text("email")
    @descr_phone = get_text("phone")
    @descr_gender = get_text("gender")
    @descr_expinterest = get_text("expinterest")
    @descr_techinterest = get_text("techinterest")
    render "audition/index" unless success
  end

  def edit
    @dancer = Dancer.find(params[:id])
  end

  def update
    # require 'pry-nav'; binding.pry
    @dancer = Dancer.find(params[:id])
    success = @dancer.update(dancer_params)
    render "audition/edit" unless success
  end

  # gets text for dynamic form
  def get_text(id)
    for formfield in FormField.where("identity = ?", (id).delete(" "))
      return formfield.text
    end
    nil
  end


  private

    def dancer_params
      params
        .require(:dancer)
        .permit(
          :name,
          :email,
          :phone,
          :gender,
          :year,
          :dance_experience,
          :exp_interest,
          :tech_interest,
          :camp_interest,
        )
    end
end
