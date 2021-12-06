class Finance < ActiveRecord::Base
  belongs_to :dancer
  before_save :default_values
  def default_values
    if self.tickets.nil?
      self.tickets = False
    end
    if self.dues.nil?
      self.dues = False
    end
  end
end
