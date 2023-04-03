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
    assign_ticket
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
    # @options = User.department_users( fetch_params[:department_selected_option] ) # using scope
    # @options = @options.with_role "admin"
    department = Department.find_by_id(fetch_params[:department_selected_option]).department_name
    # users = department.users

    role = Role.find_by_id(Department.find_by_id(fetch_params[:department_selected_option]).users.second.roles.first.id).descendants.last.name
    @options = User.with_role role

    # puts '--------------------------------'
    # puts department
    # case department
    # when "Management"
    #   # puts @options.pluck(:name)
    #   @options = User.with_role "GHI" # department k lowest role ok likhna hai 
    #   # puts @options.pluck(:name)
    # end
    render json: @options.to_json(only: [:id, :name])
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

  def upgrade
    assign_ticket
    if @ticket.save
      TicketGenerationMailer.ticket_generation(@ticket.assigned_to, current_user).deliver_later
      TicketHistory.new(ticket_id: @ticket.id, user_id: @ticket.assigned_to_id).save!
      @ticket.upgrade!
      redirect_to @ticket, notice: "Ticket is successfully updated"
    else
      render :edit
    end
  end
  
  private

  def some(d)
    case d 
    when "Management"
      return User.with_role "JKL" 
    end
  end

  def assign_ticket
    if @ticket.new_record?
        puts "new record"
        department = "Management"
        case department 
          when "Management"
            user = User.with_role "JKL"
            @ticket.assigned_to_id = user.first.id
        end
    else
      puts "old record"
      department = "Management"
      case department 
        when "Management"
          upper_role = @ticket.assigned_to.roles.first.parent
          user = User.with_role upper_role.name
          @ticket.assigned_to_id = user.first.id
      end
    end
  end

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
