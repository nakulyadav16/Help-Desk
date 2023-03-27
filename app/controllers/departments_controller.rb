class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_department, only: %i[ show edit update destroy ]
  
  def index
    @departments = Department.all
  end

  def show
  end

  def new
    @department = Department.new()
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path, notice: "New #{@department.department_name} is successfully created"
    else
      render :new
    end
  end

  def edit 
  end

  def update
    if @department.update(department_params)
      redirect_to departments_path, notice: "#{@department.department_name} is succesfully updated"
    else
      render :edit 
    end
  end

  def destroy
    @department.destroy
    redirect_to departments_path, notice: "#{@department.department_name} is succesfully deleted"
  end

  private
  def set_department
    @department = Department.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    redirect_to departments_path, notice: "Something went wrong"
  end

  def department_params
    params.require(:department).permit(:department_name)
  end
end
