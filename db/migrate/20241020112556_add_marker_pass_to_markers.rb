class AddMarkerPassToMarkers < ActiveRecord::Migration[7.1]
  def change
    add_column :markers, :marker_pass, :string
  end
end
