class Dancer < ApplicationRecord
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

  SHOW_EXP_INTEREST = true
  SHOW_TECH_INTEREST = false

  has_and_belongs_to_many :teams
  has_many :team_switch_requests

  Dancer.table_exists? && Dancer.columns.each do |column|
    if column.null == false && !["id", "created_at", "updated_at"].include?(column.name)
      validates column.name, length: { minimum: 1 }
    end
  end
end
