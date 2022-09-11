class Common::LovController < ApplicationController
    before_action :is_activated?
    before_action :is_admin?, except: :index

    def index
        @lovs = []
        Lov.filter(lov_filter_params).each_entry{ |lov| @lovs << lov&.response_hash}
        render json: @lovs
    end

    def create
        safe_operation do
            lov = Lov.new(lov_params)
            save_object(lov)
        end
    end

    def update
        safe_operation do
            lov = Lov.find(params[:id])
            update_object(lov, lov_params)
        end
    end

    def destroy
        safe_operation do
            lov = Lov.find(params[:id])
            delete_object(lov)
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