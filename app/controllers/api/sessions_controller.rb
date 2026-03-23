class Api::SessionsController < ActionController::API
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      user.rotate_session_token!

      render json: {
        message: "Logged in",
        token: user.session_token,
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role
        }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    header = request.headers["Authorization"]
    token = header.to_s.remove("Bearer ").strip

    user = User.find_by(session_token: token)

    if user
      user.rotate_session_token!

      render json: { message: "Logged out" }, status: :ok
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
