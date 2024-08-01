class CreateTeamMarkers < ActiveRecord::Migration[7.1]
  def change
    create_table :team_markers do |t|
      t.references :team, null: false, foreign_key: true
      t.references :marker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
