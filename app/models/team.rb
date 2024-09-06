class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', foreign_key: 'captain_id', optional: true
  has_many :users
end
