class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generated_slug
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(8)
  end
end
