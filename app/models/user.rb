class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :team, optional: true


  # Permet de créer une équipe pour l'utilisateur au moment de la création du profil. L'equipe est crée sans nom car la view team n'affiche que les équipes avec un nom.
  after_create :create_team

  private

  def create_team
    team = Team.create(captain: self)
    self.update(team: team) # Assurez-vous que l'utilisateur est mis à jour avec l'équipe
  end
end
