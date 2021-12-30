class SessionsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render_unauthorized
        end
    end

    def destroy
        if session[:user_id]
            session.delete :user_id
            head :no_content
        else
            render_unauthorized
        end
    end

    private

    def render_unauthorized
        render json: { errors: ["Invalid Email or Password"] }, status: :unauthorized
    end

end
