class Api::PostsController < Api::BaseController
  before_action :set_post, only: [ :show, :update, :destroy, :moderate ]

  def index
    posts = if current_user.moderator?
      Post.order(created_at: :desc)
    else
      current_user.posts.order(created_at: :desc)
    end

    render json: posts, status: :ok
  end

  def show
    return forbidden unless can_view?(@post)

    render json: @post, status: :ok
  end

  def create
    post = current_user.posts.build(post_params)
    post.status = "pending"

    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return forbidden unless owns_post?(@post) || current_user.admin?

    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return forbidden unless owns_post?(@post) || current_user.admin?

    @post.destroy
    render json: { message: "Post deleted" }, status: :ok
  end

  def moderate
    require_moderator!
    return if performed?

    if @post.update(
      status: params[:status],
      moderation_comment: params[:moderation_comment],
      moderated_by: current_user.id
    )
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def owns_post?(post)
    post.author_id == current_user.id
  end

  def can_view?(post)
    current_user.moderator? || owns_post?(post)
  end

  def forbidden
    render json: { error: "Forbidden" }, status: :forbidden
  end
end
