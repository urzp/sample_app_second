class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def destroy
    @user = User.find(params[:id])

    unless @user.admin?
      @user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    else
      flash[:danger] = "Is not allowed to delete admin"
      redirect_to users_url
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:old_password]) && @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash[:danger] = 'Invalid old password' if !@user.authenticate(params[:user][:old_password])
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      flash[:warning] = "Please sign in."
      store_location
      redirect_to signin_url
    end
  end


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
