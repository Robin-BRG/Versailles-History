class TeamsController < ApplicationController
  before_action :check_existing_team, only: [:create]
  before_action :set_team, only: [:destroy, :join, :leave]

  def index
    # Affiche toutes les équipes sauf celles dont le nom est vide ce qui est le cas des équipes crées par les utilisateurs au moment de leur inscription.
    @teams = Team.where.not(name: [nil, ''])
  end

  def create
    @team = current_user.team
    if @team.update(team_params)
      redirect_to teams_path, notice: 'Nom de l\'équipe ajouté avec succès.'
    else
      render :new, alert: "Erreur lors de la création de l'équipe."
    end
  end

  def destroy
    if @team.captain == current_user
      # Retirer tous les utilisateurs de l'équipe
      @team.users.each do |user|
        # Réassigner chaque utilisateur à son équipe initiale sans nom
        initial_team = Team.find_by(captain: user, name: nil)
        user.update(team: initial_team) if initial_team
      end
      
      # Effacer le nom de l'équipe actuelle
      @team.update(name: nil)
      
      # Réassigner le capitaine à son équipe initiale sans nom
      unnamed_team = Team.find_by(captain: current_user, name: nil)
      if unnamed_team
        current_user.update(team: unnamed_team)
      else
        new_team = Team.create(captain: current_user)
        current_user.update(team: new_team)
      end
      
      redirect_to teams_path, notice: "L'équipe a été supprimée avec succès."
    else
      redirect_to teams_path, alert: "Vous n'êtes pas autorisé à modifier cette équipe."
    end
  end

  def join
    if (current_user.team.nil? || current_user.team.name.nil?) && @team.users.count < 8
      current_user.update(team: @team)
      redirect_to teams_path, notice: "Vous avez rejoint l'équipe avec succès."
    else
      redirect_to teams_path, alert: 'Impossible de rejoindre cette équipe.'
    end
  end

  def leave
    if current_user.team == @team
      current_user.update(team: nil)
      unnamed_team = Team.find_by(captain: current_user, name: nil)
      if unnamed_team
        current_user.update(team: unnamed_team)
      else
        new_team = Team.create(captain: current_user)
        current_user.update(team: new_team)
      end
      redirect_to teams_path, notice: "Vous avez quitté l'équipe avec succès."
    else
      redirect_to teams_path, alert: "Impossible de quitter cette équipe."
    end
  end
  
  def update
    @team = current_user.team
    if @team.update(team_params)
      redirect_to teams_path, notice: "Equipe créée avec succès."
    else
      redirect_to teams_path, alert: "Erreur lors de la création de l'équipe."
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def check_existing_team
    if current_user.team.present?
      redirect_to teams_path, alert: 'Vous avez déjà une équipe.'
    end
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
