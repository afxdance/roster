class SrcFormField < ApplicationRecord
  SRC_RANGE = (1..2)
  SRC_BACKUP_RANGE = (3..4)


  def self.src
    return SrcFormField.where(id: SRC_RANGE)
  end

  def self.srcbackup
    return SrcFormField.where(id: SRC_BACKUP_RANGE)
  end

  def self.update_team_switch_fields(fields)
    SrcFormField.each_with_index do |item, index|
      item.update(data: fields[index])
    end
    return "Successfully saved changes"
  rescue StandardError
    return "Error"
  end

  def self.update_src_backup(fields)
    SrcFormField.each_with_index do |item, index|
      item.update(data: fields[index])
    end
    return "Successfully saved changes"

end
