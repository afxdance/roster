class Calendar < ApplicationRecord
  # self.table_name = "calendars"
  # belongs_to :calendars
  TIME_PATTERN = begin
    "[0-23]+:[0-59]"
  end.freeze

  REQUIRED_FIELDS = [
    :event,
    :time,
    :location
  ].freeze
  TABLE_VISIBLE_FIELDS = [
    :event,
    :time,
    :location
  ].compact.freeze

end
