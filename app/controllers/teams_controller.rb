class TeamsController < ApplicationController
  before_action :check_existing_team, only: [:create]
  before_action :set_team, only: [:destroy, :join, :leave]

  def index
    @teams = Team.all
  end

  def create
    @team = Team.new(team_params)
    @team.captain = current_user
    if @team.save
      redirect_to teams_path, notice: 'Équipe créée avec succès.'
    else
      render :new, alert: 'Erreur lors de la création de l\'équipe.'
    end
  end

  def destroy
    if @team.captain == current_user
      @team.team_markers.destroy_all
      @team.destroy
      redirect_to teams_path, notice: "Équipe supprimée avec succès."
    else
      redirect_to teams_path, alert: "Vous n'êtes pas autorisé à supprimer cette équipe."
    end
  end

  def join
    if current_user.team.nil? && @team.users.count < 8
      current_user.update(team: @team)
      redirect_to teams_path, notice: "Vous avez rejoint l'équipe avec succès."
    else
      redirect_to teams_path, alert: 'Impossible de rejoindre cette équipe.'
    end
  end

  def leave
    if current_user.team == @team
      current_user.update(team: nil)
      redirect_to teams_path, notice: "Vous avez quitté l'équipe avec succès."
    else
      redirect_to teams_path, alert: "Impossible de quitter cette équipe."
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
