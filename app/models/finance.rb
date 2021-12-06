class Finance < ActiveRecord::Base
  belongs_to :dancer
  before_save :default_values
  def default_values
    if self.tickets.nil?
      self.tickets = false
    end
    if self.dues.nil?
      self.dues = false
    end
  end
end
