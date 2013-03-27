class SessionsController < ApplicationController
  before_filter :allow_non_login_only, :except => :destroy
  
  def new
    
  end
  
  def create
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      if !user.activated
        flash.now[:warning] = "You haven't activated your account. Please check your email to activate your account now."
        render :new
      elsif user.locked
        flash.now[:warning] = "Your account has been locked by the administrator, please contact the us for more detail."
        render :new
      else      
        session[:user_id] = user.id
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        flash[:success] = "You have successfully logged in"
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Email or Password is invalid"
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    cookies.delete(:auth_token)
    flash[:success] = "You have successfully logged out"
    redirect_to root_url
  end
end
