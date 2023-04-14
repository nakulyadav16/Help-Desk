class Mesaage < ApplicationRecord
  belongs_to :users
  belongs_to :tickets

  validates :content , presence: true
end
