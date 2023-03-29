class Department < ApplicationRecord
  before_save :capitalize_name
  
  has_many :users, dependent: :destroy

  validates :department_name, presence: true

  private 
  def capitalize_name
    self.department_name = self.department_name.capitalize 
  end
end
