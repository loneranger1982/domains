class AdminController < ApplicationController
  
  def createuser
    
    
  end
  
  def save
    user=User.new
    user.email=params['email']
    user.password=params['password']
    user.save
    redirect_to(new_user_session_path)
  end
  
  
end