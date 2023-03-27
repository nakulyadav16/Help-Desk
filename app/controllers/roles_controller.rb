class RolesController < ApplicationController
  before_action :set_role, only: %i[ edit update destroy]

  def index
    @roles = Role.all
  end

  def show
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path, notice: "New #{@role.name} role is created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @role.update(role_params)
      redirect_to roles_path, notice: "#{@role.name} is successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_path, notice: "#{@role.name} is successfully deleted"
  end

  private
  def set_role
    @role = Role.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    redirect_to roles_path, notice: "Somtihng went wrong"
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
