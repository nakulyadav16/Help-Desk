class Message < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_many_attached :documents

  # validates :content ,presence: true
  validate :content_or_document

  private
  def content_or_document
    # byebug
    unless (content.present? or self.documents.attached?) 
      errors.add(:base, "Specify a content or a document, not both")
    end
  end
end
