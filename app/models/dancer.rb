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

  FINANCE_VALUES = {
    "yes" => "Has paid",
    "no" => "Has not paid",
    "other" => "Other",
  }.freeze

  TOGGLABLE_INTERESTS = [
    "Show Camp Interest",
    "Show Exp Interest",
    "Show Tech Interest",
    "Show Reach Interest",
    "Show Dues Paid",
    "Show Tickets Bought",
  ].freeze

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
    :has_paid_dues,
    :has_bought_tickets,
    :src_submitted,
  ].freeze

  # Make this a method so that it doesn't have to know what everything is right away (it queries Redis)
  def self.table_visible_fields
    return [
      :name,
      :email,
      :phone,
      :year,
      :dance_experience,
      REDIS.get("Show Camp Interest") == "true" ? :camp_interest : nil,
      REDIS.get("Show Exp Interest") == "true" ? :exp_interest : nil,
      REDIS.get("Show Tech Interest") == "true" ? :tech_interest : nil,
      REDIS.get("Show Reach Interest") == "true" ? :reach_workshop_interest : nil,
      REDIS.get("Show Reach Interest") == "true" ? :reach_news_interest : nil,
      REDIS.get("Show Dues Paid") == "true" ? :has_paid_dues : nil,
      REDIS.get("Show Tickets Bought") == "true" ? :has_bought_tickets : nil,
    ].compact
  end

  SENSITIVE_FIELDS = [
    :gender,
    :src_submitted
  ].freeze

  has_and_belongs_to_many :teams
  has_many :team_switch_requests
  has_one :src
  has_one :finance, dependent: :destroy
  before_create :build_finance

  attribute :has_paid_dues, :string, default: "no"
  attribute :has_bought_tickets, :string, default: "no"
  attribute :src_submitted, :boolean, default: false

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
      if target_max_id == 0
        temp = Dancer.new
        temp.id = target_max_id
        temp.save!(validate: false)
        reset_id
        temp.delete
      else
        reset_id
      end
    elsif target_max_id > max_id
      temp = Dancer.new
      temp.id = target_max_id
      temp.save!(validate: false)
      reset_id
      temp.delete
    else
      raise "Invalid given id: #{target_next_id}"
    end
    # rubocop:enable Style/GuardClause
  end

  def self.reset_id
    case ActiveRecord::Base.connection.adapter_name
      # reset id based on database: https://stackoverflow.com/questions/2097052/rails-way-to-reset-seed-on-id-field
    when "SQLite"
      new_max = Dancer.maximum(:id) || 0
      update_seq_sql = "update sqlite_sequence set seq = #{new_max} where name = 'dancers';"
      ActiveRecord::Base.connection.execute(update_seq_sql)
    when "PostgreSQL"
      ActiveRecord::Base.connection.reset_pk_sequence!("dancers")
    else
      raise "Task not implemented for this DB adapter"
    end
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
