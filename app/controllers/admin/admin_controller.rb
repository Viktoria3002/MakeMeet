class Admin::AdminController < ApplicationController
  before_action :authenticate_admin
  
  def index
    @stats = {
      users_count: User.count,
      posts_count: Post.count,
      comments_count: Comment.count,
      likes_count: Like.count,
      sprints_count: Sprint.count,
      participants_count: SprintParticipant.count
    }
    
    @recent_posts = Post.includes(:author).order(created_at: :desc).limit(5)
    @recent_users = User.order(registration_date: :desc).limit(5)
    @active_sprints = Sprint.active.includes(:sprint_participants)
  end

  def users
    @users = User.includes(:posts, :comments, :sprint_participants)
                 .order(registration_date: :desc)
                 .limit(50)
  end

  def posts
    @posts = Post.includes(:author, :comments, :likes)
                 .order(created_at: :desc)
                 .limit(50)
  end

  def comments
    @comments = Comment.includes(:author, :post, :likes)
                       .order(created_at: :desc)
                       .limit(50)
  end

  def sprints
    @sprints = Sprint.includes(:sprint_participants)
                     .order(start_date: :desc)
                     .limit(50)
  end

  def delete_user
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'Пользователь удален'
  end

  def delete_post
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: 'Пост удален'
  end

  def delete_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path, notice: 'Комментарий удален'
  end

  def delete_sprint
    @sprint = Sprint.find(params[:id])
    @sprint.destroy
    redirect_to admin_sprints_path, notice: 'Спринт удален'
  end

  # Редактирование
  def edit_user
    @user = User.find(params[:id])
  end

  def edit_post
    @post = Post.find(params[:id])
    @users = User.all
  end

  def edit_comment
    @comment = Comment.find(params[:id])
    @posts = Post.all
    @users = User.all
  end

  def edit_sprint
    @sprint = Sprint.find(params[:id])
  end

  # Обновление
  def update_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Пользователь обновлен'
    else
      render :edit_user
    end
  end

  def update_post
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_posts_path, notice: 'Пост обновлен'
    else
      @users = User.all
      render :edit_post
    end
  end

  def update_comment
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to admin_comments_path, notice: 'Комментарий обновлен'
    else
      @posts = Post.all
      @users = User.all
      render :edit_comment
    end
  end

  def update_sprint
    @sprint = Sprint.find(params[:id])
    if @sprint.update(sprint_params)
      redirect_to admin_sprints_path, notice: 'Спринт обновлен'
    else
      render :edit_sprint
    end
  end

  def login
    if request.post?
      username = params[:username]
      password = params[:password]
      
      # Любой логин и пароль подходит для доступа к админке
      if username.present? && password.present?
        session[:admin] = true
        redirect_to admin_root_path, notice: 'Успешный вход'
      else
        flash[:alert] = 'Введите логин и пароль'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password_hash)
  end

  def post_params
    params.require(:post).permit(:content, :author_id)
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id, :author_id)
  end

  def sprint_params
    params.require(:sprint).permit(:name, :description, :start_date, :end_date)
  end

  def authenticate_admin
    # Пропускаем аутентификацию для страницы логина
    return if action_name == 'login'
    
    # Проверяем вход в админку
    unless session[:admin]
      redirect_to admin_login_path
    end
  end
end
