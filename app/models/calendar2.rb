class Calendar2 < ApplicationRecord

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
