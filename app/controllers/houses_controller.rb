class HousesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_house, only: [ :show, :update ]

    def index
        category = params[:category]
        search = params[:search]

        @houses = House.where("category LIKE '%#{category}%' AND title LIKE '%#{search}%'").order(created_at: :desc)
        render json: @houses
    end

    def own
        @houses = House.where(user_id: authenticate_user!.id).order(created_at: :desc)
        render json: @houses
    end

    def show
        if @house
            render json: @house
        else
            render json: nil, status: :unauthorized
        end
    end

    def create
        @house = House.new(house_params)
        @house.update_attribute(:user_id, authenticate_user!.id)
        @house.save

        render json: @house
    end

    def update
        if @house
            @house.update(house_params)
            render json: @house
        else
            render json: nil, status: :unauthorized
        end
    end

    private
        def set_house
            @house = House.find_by(user_id: authenticate_user!, id: params[:id])
        end

        def house_params
            params.require(:house).permit(:title, :description, :address, :image, :category, :price, :bathroom, :bedroom, :car)
        end
end
