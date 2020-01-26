class Dancer < ApplicationRecord
  NAME_PATTERN = begin
    ".* .*"
  end.freeze
  EMAIL_PATTERN = begin
    "[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*"
  end.freeze
  PHONE_PATTERN = begin
    "[0-9]{3}-[0-9]{3}-[0-9]{4}"
  end.freeze
  GENDER_VALUES = {
    "male" => "Male",
    "female" => "Female",
    "trans_male" => "Transgender male",
    "trans_female" => "Transgender female",
    "nonconforming" => "Genderqueer/gender nonconforming",
    "decline" => "Decline to answer",
    "other" => "Other",
  }.freeze
  YEAR_VALUES = {
    "1" => "Freshman or younger",
    "2" => "Sophomore",
    "3" => "Junior",
    "4" => "Senior or older",
  }.freeze
  DANCE_EXPERIENCE_VALUES = {
    "no" => "No",
    "yes_in_afx" => "Yes, and I have been in AFX before",
    "yes_not_in_afx" => "Yes, but I have not been in AFX before",
  }.freeze

  BOOLEAN_OPTION_VALUES = {
    "true" => "Yes",
    "false" => "No",
  }.freeze

  SHOW_CAMP_INTEREST = false
  SHOW_EXP_INTEREST = false
  SHOW_TECH_INTEREST = false
  SHOW_REACH_INTEREST = false

  REQUIRED_FIELDS = [
    :name,
    :email,
    :phone,
    :gender,
    :year,
    :dance_experience,
    :exp_interest,
    :tech_interest,
    :camp_interest,
    :reach_workshop_interest,
    :reach_news_interest,
  ].freeze
  TABLE_VISIBLE_FIELDS = [
    :name,
    :email,
    :phone,
    :year,
    :dance_experience,
    SHOW_CAMP_INTEREST ? :camp_interest : nil,
    SHOW_EXP_INTEREST ? :exp_interest : nil,
    SHOW_TECH_INTEREST ? :tech_interest : nil,
    SHOW_REACH_INTEREST ? :reach_workshop_interest : nil,
    SHOW_REACH_INTEREST ? :reach_news_interest : nil,
  ].compact.freeze
  SENSITIVE_FIELDS = [
    :gender,
  ].freeze

  has_and_belongs_to_many :teams
  has_many :team_switch_requests

  for column in REQUIRED_FIELDS
    validates column, length: { minimum: 1 }
  end

  def self.next_id
    temp = Dancer.new
    temp.save!(validate: false)
    next_id = temp.id
    temp.destroy

    Dancer.next_id = next_id

    return next_id
  end

  def self.next_id=(target_next_id)
    target_max_id = target_next_id - 1
    max_id = Dancer.maximum(:id) || 0
    # require 'pry'; binding.pry

    # rubocop:disable Style/GuardClause
    if target_max_id < max_id
      raise "There are dancer ids that are greater or equal to the given id."
    elsif target_max_id == max_id
      # Do nothing
    elsif target_max_id > max_id
      temp = Dancer.new
      temp.id = target_max_id
      temp.save!(validate: false)
      Dancer.reset_sequence_name
      # temp.delete
    else
      raise "Invalid given id: #{target_next_id}"
    end
    # rubocop:enable Style/GuardClause
  end

  def self.dancers_with_no_teams
    # https://stackoverflow.com/a/5570221
    Dancer
      .includes(:dancers_teams)
      .where(dancers_teams: { dancer_id: nil })
  end

  def lowercase_name
    name.downcase
  end
end
