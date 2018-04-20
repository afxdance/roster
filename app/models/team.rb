class Team < ApplicationRecord
  has_many :users
  has_and_belongs_to_many :dancers

  def can_pick
    if type != "project"
      if Team.where("type = ? AND locked = ?", "project", false)
        # Condition above checks if there are any project teams not locked, which means the project teams are not done picking.
        return false
      end
    end
    return true
  end

  def can_add(num)
    return true if maximum_picks nil?
    return false if dancers.length + num > maximum_picks

    return true
  end

  def toggle_lock
    self[:locked] = if locked
      false
    else
      true
    end
  end

  def add_dancers(ids)
    # returns the list of added dancers to print
    added = []
    Dancer.find(Array(ids)).each do |id|
      next unless id.teams.length empty? # if the list of teams associated with a dancer is empty

      if !id.teams.include? self # if the list of teams associated with a dancer does not include this team (self)...
        id.teams << self # add the team to the list of teams
        added << id.name # add the dancer to the list of added dancers
      end
      id.save
    end
    return added
  end

  def remove_dancers(ids)
    # returns the list of removed dancers to print
    removed = []
    Dancer.find(Array(ids)).each do |id|
      next unless id.teams.length == 1

      if id.teams.include? self # if the list of teams associated with a dancer does include this team (self)...
        dancers.delete(id) # taking the dancer out of the team
        save
        id.reload
      end
      id.save
    end
    return removed
  end
end
