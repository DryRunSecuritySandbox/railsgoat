class TimeEntry < ApplicationRecord
  belongs_to :user
  validates :hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
