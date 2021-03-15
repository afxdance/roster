class SrcFormField < ApplicationRecord
  SRC_RANGE = (1..2)
  SRC_BACKUP_RANGE = (3..4)

  def self.find_src_form_fields
    return SrcFormField.src.pluck(:data).map(&:html_safe)
  end

  def self.update_src_form_fields(fields)
    SrcFormField.src.each_with_index do |item, index|
      item.update(data: fields[index])
    end
    return "Successfully saved changes"
  rescue StandardError
    return "Error"
  end

  def self.update_src_backup(fields)
    SrcFormField.srcbackup.seach_with_index do |item, index|

      item.update(data: oldDate)
    end
    return "Successfully reverted to most recent backup"
  end

  private_class_method

  def self.src
    return SrcFormField.where(id: SRC_RANGE)
  end

  def self.srcbackup
    return SrcFormField.where(id: SRC_BACKUP_RANGE)
  end
end
