class UsersController < ApplicationController


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
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

end
