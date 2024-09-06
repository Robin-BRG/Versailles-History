class AddCaptainIdToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :captain_id, :integer
    add_foreign_key :teams, :users, column: :captain_id
  end
end