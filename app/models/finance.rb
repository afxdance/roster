class Finance < ActiveRecord::Base
  belongs_to :dancer
  before_save :default_values
  def default_values
    self.tickets = false if tickets.nil?
    self.dues = false if dues.nil?
  end
end
