class PracticeController < ApplicationController
  def index

  end

  def click
    name = params[:name]
    @dancer = Dancer.find_by name:name
    @email = @dancer.email
    redirect_to "/practice/" + @email
  end

  def display
    @email = params[:email]
    render "display"
  end


end
