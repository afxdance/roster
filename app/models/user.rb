class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
<<<<<<< HEAD
  devise :database_authenticatable,
=======
  devise :database_authenticatable, 
>>>>>>> origin/team-switch-approval
         :recoverable, :rememberable, :trackable, :validatable
end
