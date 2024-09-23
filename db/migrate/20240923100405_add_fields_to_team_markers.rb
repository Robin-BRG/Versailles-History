class AddFieldsToTeamMarkers < ActiveRecord::Migration[7.1]
  def change
    add_column :team_markers, :order, :integer
    add_column :team_markers, :visited, :boolean
    add_column :team_markers, :circle_center_latitude, :float
    add_column :team_markers, :circle_center_longitude, :float
  end
end
