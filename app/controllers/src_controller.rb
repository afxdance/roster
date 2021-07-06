class SrcController < ApplicationController
  def index
    @src = Src.new
    # sees if redirect to index from submit happened
    if flash[:redirect] == "true"
      # adds to errors displayed in index
      @src.valid?
    end
    # resets redirect to false
    flash[:redirect] = false
    render "index"
  end

  def confirm
    render "confirm"
  end

  def submit
    # save form info to db
    # params["name of form element"] such as p_name, p_sign, etc...

    # TODO, i would reccomend writing all this logic of extracting parameters in the src_params method for cleaner code

    @c1 = params["a"]
    @c2 = params["b"]
    @c3 = params["c"]
    @c4 = params["d"]
    @c5 = params["e"]
    @c6 = params["f"]
    @c7 = params["g"]
    @c8 = params["h"]
    @c9 = params["i"]
    @pg_release = params["pg_release"]
    if @pg_release == "parent"
      @full_name = params["p_name"]
      @signature = params["p_sign"]
      @date = params["p_date"]
      @acknowledgment = params["p_checkbox"]
    elsif @pg_release == "myself"
      @signature = params["m_sign"]
      @date = params["m_date"]
      @acknowledgment = params["m_checkbox"]
    else
      @other = params["pg_other"]
    end
    name = params["name"]
    email = params["email"]
    phone = params["phone"]

    dancer = Dancer.where(name: name, email: email, phone: phone)
    if dancer.empty?
      # sets redirect to true when dancer doesn't exist
      flash[:redirect] = "true"
      redirect_to "/src"
    else
      @src = Src.new(c1: @c1, c2: @c2, c3: @c3, c4: @c4, c5: @c5, c6: @c6, c7: @c7, c8: @c8, c9: @c9, pg_release: @pg_release, other: @other, full_name: @full_name, signature: @signature, date: @date, acknowledgment: @acknowledgment)
      # save stuff to src
      dancer.first&.src&.destroy
      @src.dancer = dancer.first
      success = @src.save
      puts success
      redirect_to "/src/confirm" if success
    end
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
          :acknowledgment,
        )
    end
end
