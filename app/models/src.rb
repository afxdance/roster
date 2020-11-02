class Src < ApplicationRecord
  belongs_to :dancer, optional: true
  validates :dancer, presence: { message: ": You are not in our directory, please revise your information" }
end
