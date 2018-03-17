class AuditionFormController < ApplicationController
  def index
    @dancer = Dancer.new
    render 'audition_form/form'
  end

  def create_dancer
    @dancer = Dancer.new(dancer_params)
    if @dancer.save
      render 'audition_form/number'
    else
      render 'audition_form/form'
    end
  end

  private

  def dancer_params
    params.require(:dancer).permit(
      :devinterest,
      :email,
      :experience,
      :expinterest,
      :gender,
      :name,
      :phone,
      :year,
      # availability: params[:dancer][:availability] ? params[:dancer][:availability].keys : nil
    )
  end
end
