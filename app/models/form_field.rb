class FormField < ApplicationRecord
  TEAM_SWITCH_RANGE = (1..16)
  TEAM_SWITCH_BACKUP_RANGE = (17..32)

  def self.find_team_switch_fields
    return FormField.teamswitch.pluck(:data).map(&:html_safe)
  end

  def self.update_team_switch_fields(fields)
    FormField.teamswitch.each_with_index do |item, index|
      item.update(data: fields[index])
    end
    return "Successfully saved changes"
  rescue StandardError # change this to something useful
    return "Error"
  end

  # To format time object: https://apidock.com/rails/ActiveSupport/TimeWithZone/strftime
  # If each formfield becomes updated independently:
  # return FormField.first(:order => "updated_at desc", :limit => 1).updated_at
  def self.last_updated_team_switch
    return FormField.teamswitch.first.updated_at.strftime("%m/%d/%Y")
  end

  def self.last_backup_team_switch
    return FormField.teamswitchbackup.first.updated_at.strftime("%m/%d/%Y")
  end

  def self.update_team_switch_backup
    FormField.teamswitchbackup.each do |item|
      updates = FormField.find(item.id - 16).data
      item.update(data: updates)
    end
    return "New changes and backup saved"
  end

  def self.revert_team_switch_backup
    FormField.teamswitch.each do |item|
      updates = FormField.find(item.id + 16).data
      item.update(data: updates)
    end
    return "Reverted to the most recent backup"
  end

  private_class_method

  def self.teamswitch
    return FormField.where(id: TEAM_SWITCH_RANGE)
  end

  def self.teamswitchbackup
    return FormField.where(id: TEAM_SWITCH_BACKUP_RANGE)
  end
end
