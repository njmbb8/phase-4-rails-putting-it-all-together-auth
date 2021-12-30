class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
    rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized
    def create
        user = User.create!(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        end
    end

    def show
        user = User.find(session[:user_id])
        render json: user, status: :created
    end

    private

    def render_unauthorized
        render json: { error: "User Not Found"}, status: :unauthorized
    end

    def render_unprocessable(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end
end
