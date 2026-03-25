class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.username = @user.name

    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      redirect_to register_path, notice: "Вы успешно зарегистрировались в Make Meet!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :about)
  end
end