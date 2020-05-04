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
    if @pg_release == 'parent'
      @full_name = params["p_name"]
      @signature = params["p_sign"]
      @date = params["p_date"]
      @acknowledgement = params["p_checkbox"]
    elsif @pg_release == 'myself'
      @signature = params['m_name']
      @date = params['m_date']
      @acknowledgement = params["m_checkbox"]
    else 
      @other = params["pg_other"]
  

    @src = Src.new(@c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9, @pg_release, @other, @full_name, @signature, @date, @acknowledgement)
    # save stuff to src
    success = @src.save
    redirect_to "/src/confirm" unless success 
  end

end
end
