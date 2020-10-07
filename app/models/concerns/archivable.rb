module Archivable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(archived: false) }
  end

  def active?
    archived == false
  end

  def archive
    self.archived = true
    save
  end
end
