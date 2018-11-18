class UsersController < ApplicationController
  before_action :set_user,only:[:show,:edit,:update,:destroy]

  def new
    if params[:back]
        @user = User.new(user_params)
    else
        @user = User.new
    end
  end

  def confirm
    @user = User.new(user_params)
    render 'new' if @user.invalid?
  end

  def create
    @user=User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def show
  	@blogs = @user.blogs
  end

  def edit
    unless authority_check(@user.id)
      flash[:danger] = "権限がありません"
      redirect_to user_path(current_user.id)
    end
  end

  def update
		if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました！"
			redirect_to user_path(@user.id)
		else
			render 'edit'
		end
	end

  def destroy
    # 権限があって削除する場合
    if authority_check(@user.id) && @user.destroy
      flash[:notice] = "ユーザーを削除しました"
      session.delete(:user_id)
      redirect_to new_session_path
    else
      flash[:danger] = "権限がありません"
      redirect_to user_path
		end
  end

	private
	def user_params
		params.require(:user).permit(:name,:email,:password,:password_confirmation)
	end

	def set_user
		@user = User.find(params[:id])
	end
end
