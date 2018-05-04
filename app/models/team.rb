class Team < ApplicationRecord

  # relates teams and dancers
  has_and_belongs_to_many :dancers

  # could implement to tell user which dancer is conflicting
  # return array instead of boolean value so we can display names of
  # those conflicted_dancers
  def conflicted_dancers?
    for dancer in dancers
      if dancer.conflicted
        return true
      end
    end
    return false
  end

  # returns whether or not a given team can pick dancers
  def can_pick
    if !project
      # if there is a project team that is not locked,
      # do not allow training teams to pick dancers
      if Team.where("project = ? AND locked = ?", true, false)
        errors.add(:pick, "not all project teams are done picking")
        return false
      end
    end
    return true
  end

  # returns if a team can add more dancers
  def can_add(num)
    # if there is no set maximum number of picks,
    # directors can add dancers to team
    if self.maximum_picks == nil
      return true
    # if the number of dancers has exceeded the number of maximum picks,
    # directors cannot add dancers
    elsif self.dancers.length + num > self.maximum_picks
      return false
    else
      return true
    end
  end

  # if not previously locked, lock team
  def toggle_lock
    if locked
      self[:locked] = false
    else
      self[:locked] = true
    end
  end

  # attempts to add dancers with id in 'ids' array into team
  def add_dancers(ids)
    added = []
    # iterates through 'ids' and attempts to add each dancer onto team
    Dancer.find(Array(ids)).each do |id|
      # checks to see if this dancer is already on this team
      if !id.teams.include? self
        id.teams << self
        # checks to see if this dancer is part of more than 1 teams
        if id.teams.length > 1
          id.conflicted = true
        end
        id.save
      end
      # adds dancer names onto list of added dancers
      added << id.name
    end
    return added
  end

  # attempts to remove dancers with id in 'ids' array into team
  def remove_dancers(ids)
    removed = []
    Dancer.find(Array(ids)).each do |id|
      # checks to see if the dancer is on the team
      if id.team.include? self
        self.dancers.delete(id)
        self.save
        id.reload
        # if the dancer is on 1 team, dancer is not conflicted
        if id.teams.length < 2
          id.conflicted = false
        end
        id.save
        # add the removed dancer to the removed array
        removed << id.name
      end
    end
    return removed
  end

  # selects training teams sorted by smallest_first from Team
  def self.training_only_smallest_first
    Team.where("project = ?", false).sort_by { |team| team.dancers.count }
  end

  # returns whether or not project teams have finished picking
  # not needed
=begin
  def self.project_teams_done
    if Team.where("project = ? AND locked = ?", true, false)
      return false
    else
      return true
    end
  end
=end

  # are all teams done picking?
  def self.all_teams_done
    if Team.where("locked = ?", false).length > 0
      return false
    else
      return true
    end
  end

  # randomizes all dancers not yet in teams into a training team
  def self.final_randomization

    # split all auditionees not hand picked by directors into two groups based
    # on gender
    teamless = Array.new(9,[])

    # makes our code alot cleaner
    offset = 4

    # separate each dancer based on attributes
    Dancer.all.each do |dancer|
      # if dancer does't have a team yet
      if dancer.teams.length == 0
        if dancer.gender == "M"
          teamless[dancer.year] << dancer
        else
          teamless[dancer.year + offset] = dancer
        end
      end
    end

    # add all training teams to training_teams array
    training_teams = []
    Team.where("project = ?", false).each do |team|
      training_teams << team
    end

    # puts dancers into teams randomly
    if training_teams.length > 0
      teamsless.each do |group|
        while group.length > 0
          group.shuffle
          training_teams.sort! { |a,b| a.dancers.length <=> b.dancers.length }
          training_team[0].dancers << group.shift
        end
      end
    end

    # save changes!
    training_teams.each do |team|
      team.save
    end

  end

end
