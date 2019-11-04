class BlahController < ApplicationController
  def index
    render "index"
    @dancer = Dancer.new
  end

  def submit
    @dancer = Dancer.find_by name: params[:name]
    @dancer.email
    render "index"
    # redirect_to "/blah/" + @dancer.email
  end

  def display
    @email = params[:email]
    render "display"
  end

end
