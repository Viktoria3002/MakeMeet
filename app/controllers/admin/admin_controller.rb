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

  private

  def authenticate_admin
    # Простая аутентификация для админки
    # В реальном приложении здесь должна быть полноценная система авторизации
    session[:admin] ||= true # Временно разрешаем всем доступ
  end
end
