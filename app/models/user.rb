class User < ApplicationRecord
  has_and_belongs_to_many :teams
  enum role: [:director, :admin, :finance]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    authentication_keys: [:username],
  )

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def can_modify_all_teams?
    Set.new(teams) == Set.new(Team.all)
  end

  def board_privileges?
    # Jank but check if they have access to all teams
    can_modify_all_teams?
  end

  def can_modify_users?
    board_privileges?
  end

  def can_create_dancer?
    board_privileges?
  end

  def can_modify_next_dancer_id?
    board_privileges?
  end

  def can_modify_dancer_fields?
    board_privileges?
  end

  def can_view_sensitive_dancer_fields?
    board_privileges?
  end

  def table_visible_dancer_fields
    # puts Dancer.table_visible_fields
    # puts Dancer::TABLE_VISIBLE_FIELDS
    if can_view_sensitive_dancer_fields?
      # [:id] + Dancer::TABLE_VISIBLE_FIELDS
      [:id] + Dancer.table_visible_fields
    else
      # [:id] + (Dancer::TABLE_VISIBLE_FIELDS - Dancer::SENSITIVE_FIELDS)
      [:id] + (Dancer.table_visible_fields - Dancer::SENSITIVE_FIELDS)
    end
  end

  def accessible_dancer_fields
    if can_view_sensitive_dancer_fields?
      [:id] + Dancer::REQUIRED_FIELDS
    else
      [:id] + (Dancer::REQUIRED_FIELDS - Dancer::SENSITIVE_FIELDS)
    end
  end

  def can_do_randomization?
    true
  end

  def can_view_team_switch?
    if admin?
      true
    else
      false
    end
  end

  def can_view_users?
    if admin?
      true
    else
      false
    end
  end

  def can_view_dancers?
    if finance?
      false
    else
      true
    end
  end

  def can_view_teams?
    if finance?
      false
    else
      true
    end
  end

  def find_name
    if name == ""
      return username
    end
    name
  end
end
