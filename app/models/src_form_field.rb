class SrcFormField < ApplicationRecord
  SRC_RANGE = (1..28)
  SRC_BACKUP_RANGE = (29..56)

  def self.find_src_form_fields
    return SrcFormField.src.where.not(data: nil).pluck(:data).map(&:html_safe)
  end

  def self.update_src_form_fields(fields)

    SrcFormField.src.each_with_index do |item, index|
      # puts "item, index"
      # puts item
      # puts index
      # puts "item, index end"
      item.update(data: fields[index])
    end
    return "Successfully saved changes"
  rescue StandardError
    return "Error"
  end

  def self.update_src_backup
    SrcFormField.srcbackup.each do |item|
      updates = SrcFormField.find(item.id - 28).data # might be -28
      item.update(data: updates)
    end
    return "Successfully reverted to most recent backup"
  end

  # To format time object: https://apidock.com/rails/ActiveSupport/TimeWithZone/strftime
  # If each formfield becomes updated independently:
  # return FormField.first(:order => "updated_at desc", :limit => 1).updated_at
  def self.last_updated_src
    return SrcFormField.src.first.updated_at.strftime("%m/%d/%Y")
  end

  def self.last_backup_src
    return SrcFormField.srcbackup.first.updated_at.strftime("%m/%d/%Y")
  end

  def self.revert_src_backup
    SrcFormField.src.each do |item|
      updates = SrcFormField.find(item.id + 28).data
      item.update(data: updates)
    end
    return "Reverted to the most recent backup"
  end


  private_class_method

  def self.src
    return SrcFormField.where(id: SRC_RANGE)
  end

  def self.srcbackup
    return SrcFormField.where(id: SRC_BACKUP_RANGE)
  end
end
