class Dancer < ApplicationRecord
  has_and_belongs_to_many :teams
  has_many :team_switch_requests
end
