class TeamMarker < ApplicationRecord
  belongs_to :team
  belongs_to :marker

  # Callback to set the default value
  before_validation :set_default_visited, on: :create

  validates :team, presence: true
  validates :marker, presence: true
  validates :order, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :visited, inclusion: { in: [true, false] }
  validates :circle_center_latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :circle_center_longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  private

  def set_default_visited
    self.visited = false if visited.nil?
  end
end
