class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_department, only: %i[show edit update destroy]
  
  def index
    @departments = Department.all
  end

  def show
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path, notice: "New #{@department.department_name} is successfully created"
    else
      render :new, status: unprocessable_entity, alert: 'Unable to create Department.Try again..'
    end
  end

  def edit
  end

  def update
    if @department.update(department_params)
      redirect_to departments_path, notice: "#{@department.department_name} is succesfully updated"
    else
      render :edit, status: unprocessable_entity, alert: 'Unable to edit Department.Try again..'
    end
  end

  def destroy
    if @department.destroy
      redirect_to departments_path, notice: "#{@department.department_name} is succesfully deleted"
    else
      redirect_to departments_path, alert: "#{@department.department_name} cannot be deleted"
    end
  end

  private

  def set_department
    @department = Department.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to departments_path, notice: 'Record Not Found.'
  end

  def department_params
    params.require(:department).permit(:department_name)
  end
end
