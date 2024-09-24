class TeamsController < ApplicationController
  before_action :check_existing_team, only: [:create]

  def create
    @team = Team.new(team_params)
    @team.captain = current_user
    if @team.save
      respond_to do |format|
        format.html { redirect_to team_path, notice: 'Équipe créée avec succès.' }
        format.json { render json: { message: 'Équipe créée avec succès.' }, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def check_existing_team
    if current_user.team.present?
      respond_to do |format|
        format.html { redirect_to team_path, alert: 'Vous avez déjà une équipe.' }
        format.json { render json: { message: 'Vous avez déjà une équipe.' }, status: :forbidden }
      end
    end
  end
end
