class Team < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :dancers

  PROJECT = "Project".freeze
  TRAINING = "Training".freeze

  # Condition above checks if there are any project teams not locked, which means the project teams
  # are not done picking.
  def self.project_teams_still_picking?
    Team.where("level = ? AND locked = ?", PROJECT, false).any?
  end

  # Is it this teams's turn to pick dancers?
  # (Training teams can't add unless project teams are done picking.)
  def turn_to_add?
    case level
    when PROJECT
      true
    when TRAINING
      return false if Team.project_teams_still_picking?

      true
    else
      raise
    end
  end

  # rubocop:disable Naming/PredicateName
  def has_space_for?(dancers_to_add)
    new_team_size_if_the_dancers_are_added = dancers.length + dancers_to_add.length

    return true if maximum_picks.nil?

    # Checks if current team is over maximum picks (i.e. if the team still has space)
    return new_team_size_if_the_dancers_are_added <= maximum_picks
  end
  # rubocop:enable Naming/PredicateName

  # TODO: Do we need this method? Commenting out for now.
  # def toggle_lock
  #   update(locked: !locked)
  # end

  def add_dancers(dancer_ids)
    added = []
    already_in_this_team = []
    already_in_another_team = []

    Dancer.find(dancer_ids).each do |dancer|
      if dancer.teams.include? self
        already_in_this_team << dancer
      elsif dancer.teams.any?
        already_in_another_team << dancer
      else
        added << dancer
      end
    end

    # Actually add the dancers to this team
    dancers.push(*added)

    return {
      added: added,
      already_in_this_team: already_in_this_team,
      already_in_another_team: already_in_another_team,
    }
  end

  def remove_dancers(dancer_ids)
    removed = []
    not_in_this_team = []

    Dancer.find(dancer_ids).each do |dancer|
      if dancer.teams.include? self
        removed << dancer
      else
        not_in_this_team << dancer
      end
    end

    # Actually remove the dancers from this team
    dancers.delete(*removed)

    return {
      removed: removed,
      not_in_this_team: not_in_this_team,
    }
  end
end
