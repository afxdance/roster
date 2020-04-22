class SrcController < ApplicationController
  def index
    render "index"
  end

  def confirm
    render "confirm"
  end

  def submit
    # save form info to db
    # params["name of form element"] such as p_name, p_sign, etc...
    src = Src.new
    # save stuff to src
    src.save
    redirect_to "/src/confirm"
  end
end
