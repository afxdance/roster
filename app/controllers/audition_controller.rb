class AuditionController < ApplicationController
  def index
    @dancer = Dancer.new
  end

  def create
    @dancer = Dancer.new(dancer_params)
    success = @dancer.save
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
          :reach_workshop_interest,
          :reach_news_interest,
        )
    end
end
