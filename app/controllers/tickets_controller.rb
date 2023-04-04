# frozen_string_literal: true

# This controller is user for handling Tickets
class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[show edit update destroy status_transistion upgrade]

  def index
    @user_tickets = current_user.tickets
    @assigned_tickets = Ticket.user_assigned_tickets(current_user)
    @new_request_tickets = Ticket.new_request_tickets(current_user)
  end

  def show
    @ticket_assigned_history = User.all.where( id: @ticket.ticket_histories.pluck(:user_id)).pluck(:name)
  end

  def new
    @ticket = current_user.tickets.new
    @departments = Department.all
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)
    @ticket.due_date = (Date.today + 3).to_s
    if @ticket.save
      TicketGenerationMailer.ticket_generation(@ticket.assigned_to, current_user).deliver_later
      TicketHistory.new(ticket_id: @ticket.id, user_id: @ticket.assigned_to_id).save!
      redirect_to tickets_path, notice: "New Ticket is successfully created"
    else
      render :new
    end
  end

  def edit
    @departments = Department.all
  end

  def update
    if @ticket.update(ticket_params)
      TicketGenerationMailer.ticket_generation(@ticket.assigned_to, current_user).deliver_later
      TicketHistory.new(ticket_id: @ticket.id, user_id: @ticket.assigned_to_id).save!
      @ticket.upgrade!
      redirect_to @ticket, notice: "Ticket is successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @ticket.destroy
    redirect_to tickets_path, notice: "Ticket is successfully deleted"
  end

  def fetch
    @department_users = Department.find_by_id(fetch_params[:department_selected_option]).users
    @assign_to = ''
    if @department_users.count != 0
      role = Role.find_by_id(@department_users.first.roles.first.id)
      department_role_herarchicy_by_name = (role.path.pluck(:name) + role.descendants.pluck(:name)).reverse
      for role in department_role_herarchicy_by_name do 
        if @department_users.with_role role != nil
          @assign_to = (@department_users.with_role role)
          break
        end
      end
    end
    render json: @assign_to.to_json(only: [:id, :name])
  end

  # aasm event calling action
  def status_transistion
    case params[:transistion]
      when "accept"
        @ticket.accept!
      when "reject"
        @ticket.reject!
      when "satisfy"
        @ticket.satisfy!
      when "close"
        @ticket.close!
    end
    redirect_to @ticket
  end

  def upgrade
    if assign_ticket
      if @ticket.save
        TicketGenerationMailer.ticket_generation(@ticket.assigned_to, current_user).deliver_later
        TicketHistory.new(ticket_id: @ticket.id, user_id: @ticket.assigned_to_id).save!
        @ticket.upgrade!
        redirect_to @ticket, notice: "Ticket is successfully upgraded"
      else
        redirect_to @ticket, alert: "Ticket is upgradation failed. Try again"
      end
    else
      redirect_to @ticket, alert: "Ticket can not be upgrade. You are already on top level!!"
    end
  end
  
  private

  def assign_ticket
    @department_users = Department.find_by_id(@ticket.department_id).users
    upper_role_by_name = (@ticket.assigned_to.roles.first.ancestors.pluck(:name)).reverse
    if upper_role_by_name.count != 0
      for role in upper_role_by_name do 
        if (@department_users.with_role role).count != 0
          @ticket.assigned_to_id  = (@department_users.with_role role).sample.id
          return true
        end
      end
    else
      return false
    end
  end

  def set_ticket
    @ticket = Ticket.find_by_id(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    redirect_to tickets_path, notice: "Something went wrong"
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :description, :due_date, :priority, :department_id, :assigned_to_id, :user_id, documents: [])
  end

  def fetch_params
    params.permit(:department_selected_option)
  end
end
