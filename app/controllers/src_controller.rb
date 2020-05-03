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
    src = Src.new(src_params)
    # save stuff to src
    success = src.save
    redirect_to "/src/confirm" unless success 
  end

  private

    def src_params
      params
        .require(:Src)
        .permit(
          :c1,
          :c2,
          :c3,
          :c4,
          :c5,
          :c6,
          :c7,
          :c8,
          :c9,
          :pg_release,
          :other,
          :full_name,
          :signature,
          :date,
          :acknowledgement,
        )
    end
end
