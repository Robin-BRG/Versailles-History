class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', foreign_key: 'captain_id', optional: true
  has_many :users
  has_many :team_markers

  # Only validate on creation
  validate :single_team_per_user, on: :create

  private

  def single_team_per_user
    if captain && Team.where(captain: captain).exists?
      errors.add(:base, "Vous ne pouvez créer qu'une seule équipe.")
    end
  end
end
