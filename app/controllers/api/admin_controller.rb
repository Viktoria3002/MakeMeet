# app/controllers/api/admin_controller.rb
class Api::AdminController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :authorize_admin!

  def overview
    latest_posts = Post.order(created_at: :desc).limit(5)
    latest_users = User.order(created_at: :desc).limit(5)

    render json: {
      counts: {
        users: User.count,
        posts: Post.count,
        comments: Comment.count,
        sprints: (defined?(Sprint) ? Sprint.count : 0)
      },
      latest_posts: latest_posts.map { |p|
        {
          id: p.id,
          title: p.respond_to?(:title) ? p.title : "Post ##{p.id}",
          created_at: p.created_at
        }
      },
      latest_users: latest_users.map { |u|
        {
          id: u.id,
          username: u.respond_to?(:username) ? u.username : nil,
          email: u.respond_to?(:email) ? u.email : nil,
          created_at: u.created_at
        }
      }
    }
  end

  private

  def authorize_admin!
    token = request.headers["Authorization"].to_s.sub("Bearer ", "")
    expected = ENV["RAILS_ADMIN_TOKEN"].to_s
    head :unauthorized if expected.empty? || token != expected
  end
end
