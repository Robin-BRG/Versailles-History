class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', foreign_key: 'captain_id', optional: true
  has_many :users
  has_many :team_markers

  validates :name, presence: true
  validate :single_team_per_user

  private

  def single_team_per_user
    if captain && captain.team.present?
      errors.add(:base, "Vous ne pouvez créer qu'une seule équipe.")
    end
  end
end
