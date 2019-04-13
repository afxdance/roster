class Calendar2 < ApplicationRecord
  # self.table_name = "calendars"
  # belongs_to :calendars

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
