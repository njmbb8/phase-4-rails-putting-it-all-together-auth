class RecipesController < ApplicationController
    before_action :authorize
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable

    def index
        render json: Recipe.all
    end

    def create
        params[:user_id] = session[:user_id]
        recipe = Recipe.create!(recipe_params)
        render json: recipe, status: :created
    end

    private

    def render_unprocessable(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end
end
