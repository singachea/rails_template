class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    sort_key = User.sort_orders(params[:sort])
    @users = User.order(sort_key).page(params[:page]).per_page(DEFAULT_PAGE_SIZE)
  end

  def new
    params[:user] ={:role => "member"}
    @user = User.new(params[:user], :as => :admin)
  end

  def create
    @user = User.new(params[:user], as: :admin)
    if @user.save
     redirect_to [:admin, @user], :flash => { :success => "You have successfully created a new user"}
    else
     render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
     redirect_to [:admin, @user], :flash => { :success => "You just edited #{@user.email}"}
    else
     render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url(:page => params[:page])
  end


  def toggle
    @user = User.find_by_id(params[:id])
    result = toggle_field @user
    render json: result
  end
end