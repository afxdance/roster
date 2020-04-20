class FormField < ApplicationRecord
	TEAM_SWITCH_RANGE = (1..16)
  TEAM_SWITCH_BACKUP_RANGE = (18..33)

	def self.getTeamSwitchFields
		return FormField.teamswitch.pluck(:data).map{|data| data.html_safe}
	end

	def self.setTeamSwitchFields(fields)
		begin
			FormField.teamswitch.each_with_index do |item, index|
				item.update(data: fields[index])
			end
			return "Successfully saved changes"
		rescue Error #change this to something useful
			return "Error"
		end
	end

	def self.lastUpdated
		return FormField.where().first.updated_at.strftime("%m/%d/%Y")
		# To format time object: https://apidock.com/rails/ActiveSupport/TimeWithZone/strftime
		# If each formfield becomes updated independently:
		# return FormField.first(:order => "updated_at desc", :limit => 1).updated_at
  end

  def self.setTeamSwitchBackup
    FormField.teamwwitchbackup.each do |item|
      updates = FormField.where(id: item.id - 17).data
      item.update(data: updates)
    end
    return "Backup saved"
  end

  def self.revertTeamSwitchBackup
    FormField.teamswitch.each do |item|
      updates = FormField.where(id: item.id + 17).data
      item.update(data: updates)
    end
    return "Reverted to the most recent backup"
  end

  private

  def self.teamswitch
		return FormField.where(id: TEAM_SWITCH_RANGE)
  end

  def self.teamSwitchbackup
    return FormField.where(id: TEAM_SWITCH_BACKUP_RANGE)
  end

end
