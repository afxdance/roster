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

  def edit_dancer
    @dancer = Dancer.find(dancer_params[:id])
    if @dancer.update_attributes(dancer_params[:post])
      render 'audition_form/number'
    else
      render 'edit'
    end
  end
  #   respond_to do |format|
  #     if @dancer.update_attributes(params[:post])
  #       format.html  { redirect_to(@dancer,
  #                     :notice => 'Post was successfully updated.') }
  #       format.json  { head :no_content }
  #     else
  #       format.html  { render :action => "edit" }
  #       format.json  { render :json => @dancer.errors,
  #                     :status => :unprocessable_entity }
  #     end
  #   end
  # end

  def edit
    @dancer = Dancer.find(dancer_params[:id])
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
