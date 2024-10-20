class RemoveAccessTokenFromMarkers < ActiveRecord::Migration[7.1]
  def change
    remove_column :markers, :access_token, :string
  end
end
