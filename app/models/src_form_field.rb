class SrcFormField < ApplicationRecord
  SRC_RANGE = (1..4)
  SRC_BACKUP_RANGE = (4..8)


  def self.find_src_form_fields
    return SrcFormField.src.pluck(:data).map(&:html_safe)
  end

  def self.update_src_form_fields(fields)
    # puts "src_form_field start"
    # puts fields
    # puts SrcFormField.src
    # puts "src_form_field end"

    # if SrcFormField.src.size < SRC_RANGE.size
    #   for i in SRC_RANGE
    #     SrcFormField.create(id: i, data: "testing", created_at: "Sun, 14 Mar 2021 20:16:10 PDT -07:00", updated_at: "Sun, 14 Mar 2021 20:16:10 PDT -07:00")
    #   end
    # end
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
