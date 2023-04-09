# frozen_string_literal: true

# This controller is user for handling Tickets
class TicketsController < ApplicationController
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
    if @ticket.save
      send_mail_and_create_history(@ticket)
      redirect_to tickets_path, notice: t('notice.new_ticket')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ticket.update(ticket_params)
      send_mail_and_create_history(@ticket)
      @ticket.upgrade!
      redirect_to @ticket, notice: t('notice.ticket_updated')
    else
      render :edit
    end
  end

  def destroy
    @ticket.destroy
    redirect_to tickets_path, notice: t('notice.ticket_deleted')
  end

  def fetch
    assign_to = fetch_user(selected_department_params[:department_selected_option])
    render json: assign_to.to_json(only: %i[id name])
  end

  def status_transistion
    if perform_transistion(params[:transistion])
      redirect_to @ticket
    else
      redirect_to @ticket, notice: t('notice.transistion_failed')
    end
  end

  def upgrade
    if assign_ticket_to_superior
      if @ticket.save
        send_mail_and_create_history(@ticket)
        @ticket.upgrade!
        redirect_to @ticket, notice: t('notice.ticket_upgraded')
      else
        redirect_to @ticket, alert: t('notice.ticket_upgrade_failed')
      end
    else
      redirect_to @ticket, alert: t('notice.top_level_ticket')
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
    department_users = Department.includes(users: :roles).find_by_id(@ticket.department_id).users
    superior_role_hierarchy = @ticket.assigned_to.roles.first.ancestors.pluck(:name).reverse
    superior_role_hierarchy.each do |role|
      users = department_users.with_role(role)
      if users.any?
        @ticket.assigned_to_id = users.sample.id
        break
      end
    end
    @ticket.assigned_to_id != old_assigned_user_id
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
    else
      raise ArgumentError.new()
    end
    TicketGenerationMailer.ticket_acceptance(@ticket).deliver_later
    return true
  rescue ArgumentError
    false
  end

  def send_mail_and_create_history(ticket)
    TicketGenerationMailer.ticket_generation(ticket.assigned_to, current_user).deliver_later
    TicketHistory.create(ticket_id: ticket.id, user_id: ticket.assigned_to_id)
  end

  def ticket_history
    @ticket.ticket_histories
           .joins(:user)
           .select('users.name', :created_at)
           .map { |history| [history.name, history.created_at] }
  end
  

  def find_ticket
    @ticket = Ticket.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tickets_path, notice: t('notice.ticket_not_found')
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :description, :due_date, :priority, :department_id,
                                   :assigned_to_id, :user_id, documents: [])
  end

  def selected_department_params
    params.permit(:department_selected_option)
  end
end
