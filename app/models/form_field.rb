class FormField < ApplicationRecord
	def self.getTeamSwitchFields
		return FormField.where(id: 1..16).pluck(:data).map{|data| data.html_safe}
	end

	def self.setTeamSwitchFields(fields)

	end
end
