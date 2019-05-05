class FormField < ApplicationRecord
  def name
  	return "hi"
  end
   REQUIRED_FIELDS = [
    :text,
    :id
  ].freeze
end