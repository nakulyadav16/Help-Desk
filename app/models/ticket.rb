class Ticket < ApplicationRecord
  before_save :add_due_date,if: :new_record? || :assigned_to_changed?
  # Validations
  validates :subject ,:description ,:department_id, :assigned_to, :priority , presence: true
  
  # Associations
  has_many :messages , dependent: :destroy
  belongs_to :creator,class_name: 'User'
  belongs_to :assigned_to ,class_name: 'User'  
  belongs_to :department 
  has_many :ticket_histories, dependent: :destroy

  # attachment
  has_many_attached :documents

  # Scopes
  scope :user_assigned_tickets, ->(current_user) { current_user.assigned_tickets.where("status = 'in_progress' or status = 'closed'") }
  scope :new_request_tickets, ->(current_user) { current_user.assigned_tickets.where("status = 'open' or status = 're_open'") }
  
  def self.priority_order(tickets)
    tickets.order(
      Arel.sql(<<-SQL.squish 
        CASE 
        WHEN priority = 'High' THEN '1' 
        WHEN priority = 'Medium' THEN '2' 
        WHEN priority = 'Low' THEN '3' 
        END 
      SQL
      ) )
  end

  def self.due_date_order(tickets)
    tickets.order(due_date: :asc)
  end
  # AASM code
  include AASM 

  aasm column: :status do
    state :open,initial: true
    state :in_progress , :rejected , :pending , :closed , :re_open

    event :accept do 
      transitions from: [:open , :re_open ] , to: :in_progress
    end

    event :reject do 
      transitions from: [ :open , :re_open ] , to: :rejected
    end

    event :after_due_date do 
      transitions from: [ :in_progress ] , to: :pending
    end

    event :satisfy do 
      transitions from: [ :in_progress , :pending ] , to: :closed
    end

    event :upgrade do 
      transitions from: [:pending , :in_progress, :rejected , :closed ] , to: :re_open
    end

    event :close do 
      transitions from: [:open , :re_open , :rejected ] , to: :closed
    end
  end

  def add_due_date
    self.due_date = (Date.today() + 3).to_s
  end
end

