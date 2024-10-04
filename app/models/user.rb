class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :team, optional: true


  # Permet de créer une équipe pour l'utilisateur au moment de la création du profil. L'equipe est crée sans nom car la view team n'affiche que les équipes avec un nom.
  after_create :create_team_and_markers

  private

  def create_team_and_markers
    team = Team.create(captain: self)
    self.update(team: team)

    markers = Marker.order(:id).to_a
    hotel_le_louis = markers.find { |marker| marker.name == "Hôtel Le Louis" }
    markers.delete(hotel_le_louis)
    markers.shuffle!
    markers << hotel_le_louis

    markers.each_with_index do |marker, index|
      TeamMarker.create!(
        team_id: team.id,
        marker_id: marker.id,
        order: index,
        visited: false,
        circle_center_latitude: random_in_range(marker.latitude - 0.001, marker.latitude + 0.001).clamp(-90, 90),
        circle_center_longitude: random_in_range(marker.longitude - 0.001, marker.longitude + 0.001).clamp(-180, 180),
      )
    end
  end

  def random_in_range(min, max)
    (rand * (max - min)) + min
  end
end
