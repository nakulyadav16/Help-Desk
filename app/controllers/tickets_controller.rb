# frozen_string_literal: true

# This controller is user for handling Tickets
class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_ticket, only: %i[show edit update destroy status_transistion upgrade]

  def index
    @tickets = Ticket.ransack(params[:q])
    @user_tickets = TicketManager::UserTicketFinder.call(current_user, params[:q])
    @assigned_tickets = TicketManager::UserAssignedTicketFinder.call(current_user, params[:q])
    @new_request_tickets = TicketManager::NewRaisedTicketFinder.call(current_user, params[:q])
  end

  def show
    @ticket_assigned_history = TicketManager::TicketHistories.call(@ticket)
    @ticket_messages = @ticket.messages
  end

  def new
    @ticket = current_user.tickets.new
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)
    if @ticket.save
      TicketManager::SendMailAndCreateHistory.call(@ticket)
      redirect_to tickets_path, notice: t('notice.new_ticket')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ticket.update(ticket_params)
      TicketManager::SendMailAndCreateHistory.call(@ticket, current_user)
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
    assign_to = TicketManager::UserFinder.call(selected_department_params)
    render json: assign_to.to_json(only: %i[id name])
  end

  def status_transistion
    if TicketManager::PerformTransistion.call(params[:transistion], @ticket)
      redirect_to @ticket
    else
      redirect_to @ticket, notice: t('notice.transistion_failed')
    end
  end

  def upgrade
    if TicketManager::FindSuperior.call(@ticket)
      if @ticket.save
        TicketManager::SendMailAndCreateHistory.call(@ticket, current_user)
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

  def find_ticket
    @ticket = Ticket.friendly.find(params[:slug])
  rescue ActiveRecord::RecordNotFound => error
    redirect_to tickets_path, notice: "Something went wrong"
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :description, :due_date, :priority, :department_id,
                                   :assigned_to_id, :user_id, documents: [])
  end

  def selected_department_params
    params.permit(:department_selected_option)
  end
end
