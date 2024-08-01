class AddForeignKeyToTeamMarkers < ActiveRecord::Migration[7.1]
  def change
    unless foreign_key_exists?(:team_markers, :markers)
      add_foreign_key :team_markers, :markers
    end

    unless foreign_key_exists?(:team_markers, :teams)
      add_foreign_key :team_markers, :teams
    end
  end
end