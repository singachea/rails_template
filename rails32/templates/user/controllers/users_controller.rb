class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :show, :update, :aleady_logged_in]
  before_filter :allow_non_login_only, :only => [:new, :create, :forget_password, :post_forget_password, :retrieve_password, :activate]
  
  #layout "layouts/login", :only => [:new, :create, :forget_password, :post_forget_password, :retrieve_password, :activate]
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find_by_id(session[:user_id])
  end
  
  def create
    @user = User.new(params[:user])
    @user.role = "member"
    @user.activated = false
    if @user.save
      #MailUser.send_activation_link(@user.id).deliver # to be enqueed
      #Resque.enqueue(SendActivationLinkWorker, @user.id)
      SendActivationLinkWorker.perform_async(@user.id)
      redirect_to login_url, :notice => "It's almost done! Please check your email to activate your account"
    else
      render :new
    end
  end

  def edit
    @user = User.find_by_id(session[:user_id])
  end
  
  def update
    @user = User.find_by_id(session[:user_id])
    
    params[:user].delete(:email)
    
    if @user.update_attributes(params[:user])
      flash[:success] = "You have successfully updated your profile"
      redirect_to root_url
    else
      render :edit
    end  
  end
  
  
  def forget_password
  end
  
  def post_forget_password
    if params[:email].blank?
      flash.now[:danger] = "You need to enter email"
      return render :forget_password
    end
    
    user = User.find_by_email(params[:email])
    if user.nil?
      flash.now[:danger] = "The email doesn't exist in our database"
      return render :forget_password
    end
    
    #MailUser.forget_password(user.id).deliver #to be enqueued
    #Resque.enqueue(ForgetPasswordWorker, user.id)
    ForgetPasswordWorker.perform_async(user.id)
    flash[:success] = "We already sent an email to you. please check your account"
    params.delete(:email)
    redirect_to login_url
  end
  
  def retrieve_password    
    if is_expired = (Time.at(params[:expired].to_i) < Time.now) rescue true
      flash[:danger] = "You link was already expired. Enter your email again to receive new link"
      return redirect_to forget_password_profile_url
    elsif (user = User.find_by_id(params[:id])).nil?
      flash[:danger] = "You enter an invalid link. Enter your email again to receive new link"
      return redirect_to forget_password_profile_url
    elsif !(is_matched = Digest::SHA1.hexdigest("#{params[:expired]}#{user.password_recoverable}") == params[:digest])
      flash[:danger] = "You enter an invalid link. You might have already activated this link once. Enter your email again to receive new link"
      return redirect_to forget_password_profile_url
    end
    
    user.password = user.password_confirmation = Digest::SHA1.hexdigest(params[:digest]).first(8)
    user.password_recoverable = SecureRandom.uuid.gsub("-", "")
    user.save
    
    session[:user_id] = user.id
    flash[:success] = "You have successfully activated your password to #{user.password}. Perhaps, you might want to change your password to an easier one to remember right now."
    return redirect_to edit_profile_url
  end

  def activate
    user = User.find_by_id(params[:id])
    is_matched = Digest::SHA1.hexdigest("#{params[:id]}#{params[:key]}#{ACTIVATION_KEY}") == params[:digest]
    
    if user.nil? || !is_matched
      flash[:danger] = "You enter an invalid link."
      return redirect_to root_url
    end
    
    user.update_attribute("activated", true)
    
    flash[:success] = "You have successfully activated your account."
    return redirect_to login_url
  end
end
