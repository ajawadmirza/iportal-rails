class Common::LovController < ApplicationController
    before_action :is_activated?
    before_action :is_admin?, except: :index

    def index
        @lovs = []
        Lov.filter(lov_filter_params).each_entry{ |lov| @lovs << lov&.response_hash}
        render json: @lovs
    end

    def create
        begin
            lov = Lov.new(lov_params)
            save_object(lov)
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def update
        begin
            lov = Lov.find(params[:id])
            update_object(lov, lov_params)
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    def destroy
        begin
            lov = Lov.find(params[:id])
            delete_object(lov)
        rescue => e
            render json: { errors: e.message }, status: :internal_server_error
        end
    end

    private

    def lov_filter_params
        params.slice(:id, :category)
    end

    def lov_params
        params.permit(:category, :name, :value)
    end
end