class Src < ApplicationRecord

  ActiveAdmin.register Src do
    menu if: proc { current_user.admin? }
  end

  belongs_to :dancer, optional: true
  validates :dancer, presence: { message: ": You are not in our directory, please revise your information" }
end
