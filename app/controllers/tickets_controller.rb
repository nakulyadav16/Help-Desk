# frozen_string_literal: true

# This controller is user for handling Tickets
class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[ show edit update destroy status_transistion ]

  def index
    @user_tickets = current_user.tickets
    @assigned_tickets = Ticket.user_assigned_tickets(current_user)
    @new_request_tickets = Ticket.new_request_tickets(current_user)
  end

  def show
  end

  def new
    @ticket = current_user.tickets.new
    @departments = Department.all
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)
    if @ticket.save
      TicketGenerationMailer.ticket_generation(@ticket.assigned_to, current_user).deliver_later
      redirect_to tickets_path, notice: "New Ticket is successfully created"
    else
      redirect_to new_ticket_path
    end
  end

  def edit
    @departments = Department.all
  end

  def update
    if @ticket.update(ticket_params)
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
    options = User.department_users( fetch_params[:department_selected_option] ) # using scope
    render json: options.to_json(only: [:id, :name])
  end

  # aasm event calling methods
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
  
  private
  def set_ticket
    @ticket = Ticket.find_by_id(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    redirect_to tickets_path, notice: "Something went wrong"
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :description, :due_date, :priority, :department_id, :assigned_to_id, :user_id, documents: [] )
  end

  def fetch_params
    params.permit(:department_selected_option)
  end
end
