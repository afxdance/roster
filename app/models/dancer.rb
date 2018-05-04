class Dancer < ApplicationRecord
  # relating dancer class to teams and team_switch_requests
  has_and_belongs_to_many :teams
  has_many :team_switch_requests

  # not sure what this does yet :/
  serialize :availability, Hash

  # following statements serve to validate different elements of the dancers
  # for example, the following line makes sure each of these variables exist
  validates :name, :year, :gender, :experience, :email, :phone, presence: true
  # this line makes sure that the email is at least in the correct form
  validates :email, format: { :with => /@/,
          message: "is not valid." }
  # this line makes sure the phone number is in a valid format
  validates :phone, format: { with: /\d{3}-\d{3}-\d{4}/,
          message: "must be in the format of XXX-XXX-XXXX." }

  #
  def unavailable_for_teams
    result = teams.select{ |team| unavailable_for? team }.sort_by(&:name)
  end

  # if a dancer is unavailable for a team, the availibility will be set to "0"
  def unavailble_for?(team)
    availibility[team.id.to_s] == "0"
  end

  def time_conflict_reassign_candidate?
    return false unless teams.length == 1
    old_team = teams[0]
    return false unless old_team.project == false
    return false unless unavailable_for?(old_team)
    true
  end

  def time_conflict_reassign_suggest
    for new_team in Team.training_only_smallest_first
      unless unavailable_for? new_team
        return new_team
      end
    end
    return nil
  end

  def self.time_conflict_reassign!
    dancers_to_reassign = []
    for dancer in Dancer.all
      next unless dancer.time_conflict_reassign_candidate?
      puts "Found dancer to reassign: #{dancer.id}"
      dancers_to_reassign.append dancer
    end

    for dancer in dancers_to_reassign
      puts "Old teams for dancer #{dancer.id}: #{dancer.teams.map(&id)}"
      raise "Internal error" unless dancer.teams.length == 1
      old_team = dancer.teams.first
      puts "Clearing teams for dancer: #{dancer.id}. To undo: \
      Dancer.find(#{dancer.id}).teams.clear.append Team.find(#{old_team.id})"
      dancer.teams.clear
    end

    for dancer in dancers_to_reassign
      dancer.teams.append dancer.time_conflict_reassign_suggest
      puts "New teams for dancer #{dancer.id}: #{dancer.teams.map(&:id)}"
    end

    return nil
  end
end
