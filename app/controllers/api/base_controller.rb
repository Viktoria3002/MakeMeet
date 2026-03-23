class Api::BaseController < ActionController::API
  before_action :authenticate_user!

  attr_reader :current_user

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header.to_s.remove("Bearer ").strip

    @current_user = User.find_by(session_token: token)

    unless @current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def require_moderator!
    unless current_user&.moderator?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  def require_admin!
    unless current_user&.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end