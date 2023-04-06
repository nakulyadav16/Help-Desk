# frozen_string_literal: true

# This controller is user for handling Tickets
class TicketsController < ApplicationController
  include Tickets
  DAYS_TO_ADD = 3
  before_action :authenticate_user!
  before_action :find_ticket, only: %i[show edit update destroy status_transistion upgrade]

  def index
    @user_tickets = current_user.tickets
    @assigned_tickets = Ticket.assigned_tickets(current_user)
    @new_raised_tickets = Ticket.new_raised_tickets(current_user)
  end

  def show
    @ticket_assigned_history = ticket_history
    @ticket_messages = @ticket.messages
  end

  def new
    @ticket = current_user.tickets.new
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)
    @ticket.due_date = (Date.today + DAYS_TO_ADD).to_s
    if @ticket.save
      send_mail_and_create_history(@ticket)
      redirect_to tickets_path, notice: 'New Ticket is successfully created'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ticket.update(ticket_params)
      send_mail_and_create_history(@ticket)
      @ticket.upgrade!
      redirect_to @ticket, notice: 'Ticket is successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @ticket.destroy
    redirect_to tickets_path, notice: 'Ticket is successfully deleted'
  end

  def fetch
    assign_to = fetch_user(selected_department_params[:department_selected_option])
    render json: assign_to.to_json(only: %i[id name])
  end

  def status_transistion
    perform_transistion(params[:transistion])
    redirect_to @ticket
  end

  def upgrade
    if assign_ticket_to_superior
      if @ticket.save
        send_mail_and_create_history(@ticket)
        @ticket.upgrade!
        redirect_to @ticket, notice: 'Ticket is successfully upgraded'
      else
        redirect_to @ticket, alert: 'Ticket is upgradation failed. Try again'
      end
    else
      redirect_to @ticket, alert: 'Ticket can not be upgrade. You are already on top level!!'
    end
  end

  private

  def fetch_user(department_id)
    department_users = Department.find_by_id(department_id).users
    if department_users.count != 0
      role = Role.find_by_id(department_users.first.roles.first.id)
      department_role_herarchicy_by_name = (role.path.pluck(:name) + role.descendants.pluck(:name)).reverse
      department_role_herarchicy_by_name.each do |role|
        if !(department_users.with_role role).nil?
          return (department_users.with_role role)
        end
      end
    end
  end

  def assign_ticket_to_superior
    old_assigned_user_id = @ticket.assigned_to_id
    department_users = Department.find_by_id(@ticket.department_id).users
    superior_role_by_name = @ticket.assigned_to.roles.first.ancestors.pluck(:name).reverse
    if superior_role_by_name.count != 0
      superior_role_by_name.each do |role|
        if (department_users.with_role role).count != 0
          @ticket.assigned_to_id = (department_users.with_role role).sample.id
          break
        end
      end
    else
      return false
    end
    @ticket.assigned_to_id == old_assigned_user_id ? false : true
  end

  def perform_transistion(transistion)
    case transistion
    when 'accept'
      @ticket.accept!
    when 'reject'
      @ticket.reject!
    when 'satisfy'
      @ticket.satisfy!
    when 'close'
      @ticket.close!
    end
    TicketGenerationMailer.ticket_acceptance(@ticket).deliver_later
  end

  def send_mail_and_create_history(ticket)
    TicketGenerationMailer.ticket_generation(ticket.assigned_to, current_user).deliver_later
    TicketHistory.create(ticket_id: ticket.id, user_id: ticket.assigned_to_id)
  end

  def ticket_history
    ids = @ticket.ticket_histories.pluck(:user_id)
    user_name = User.find(ids).index_by(&:id).values_at(*ids).pluck(:name)
    ticket_history = @ticket.ticket_histories.pluck(:user_id, :created_at)
    ticket_history.each_with_index do |ele, index|
      ele[0] = user_name[index]
    end
    ticket_history
  end

  def find_ticket
    @ticket = Ticket.find_by_id(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tickets_path, notice: 'Something went wrong'
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :description, :due_date, :priority, :department_id,
                                   :assigned_to_id, :user_id, documents: [])
  end

  def selected_department_params
    params.permit(:department_selected_option)
  end
end
