class User < ApplicationRecord
  rolify

  after_create :assign_role

  attr_accessor :role

  belongs_to :department, optional: true
  has_many :tickets, class_name: 'Ticket' ,foreign_key: 'creator_id', dependent: :destroy
  has_many :assigned_tickets, class_name: 'Ticket',foreign_key: 'assigned_to_id', dependent: :destroy
  has_many :messages ,through: :tickets
  has_one_attached :profile_pic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true
  validates :contact, presence: true, uniqueness: { allow_blank: true }
  validates :department_id, presence: true
  validates :dob, presence: true
  validate :check_age

  scope :department_users, ->(selected_department) { where("department_id = ?", selected_department) }
  
  private

  def assign_role
    self.add_role role
    puts role
  end

  def check_age
    if(dob != nil)
      if(Date.today.year - dob.year)<=18
        self.errors.add(:dob," must be greater than 18.")
      end
    end
  end
end