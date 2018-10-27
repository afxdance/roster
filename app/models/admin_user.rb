class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  belongs_to :team
  
  accepts_nested_attributes_for :team, :allow_destroy => true
  
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
         
  # admin
  # board
  # project director
  # training director
  
  validates :admin_type, inclusion: { 
    in: %w(admin board project training),
    message: "Must be either: admin, board, project or training."
  }
  
end
