class Message < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_many_attached :documents

  # validates :content 
end
