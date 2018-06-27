class User < ApplicationRecord
  has_and_belongs_to_many :teams
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

  def board_privileges?
    # Jank but check if they have access to all teams
    Set.new(teams) == Set.new(Team.all)
  end

  def can_modify_users?
    true
  end

  def can_create_dancer?
    true
  end

  def can_modify_next_dancer_id?
    board_privileges?
  end

  def can_modify_dancer_fields?
    true
  end

  def can_view_sensitive_dancer_fields?
    board_privileges?
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
end
