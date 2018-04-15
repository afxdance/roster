class AuditionFormController < ApplicationController
  def index
    @dancer = Dancer.new
    render "audition_form/form"
  end

  def create_dancer
    @dancer = Dancer.new(dancer_params)
    if @dancer.save
      render "audition_form/number"
    else
      render "audition_form/form"
    end
  end

  def edit
    @dancer = Dancer.find(params[:id])
  end

  def update
    @dancer = Dancer.find(params[:id])
    @dancer.update(name: params[:dancer][:name], phone: params[:dancer][:phone], year: params[:dancer][:year],
                   gender: params[:dancer][:gender], email: params[:dancer][:email],
                   experience: params[:dancer][:experience])
    render "audition_form/updated"
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
