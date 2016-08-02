module Api
  module Users
    class JobsController < ApiController
      before_action :set_base_user

      def index
        render json: @user.jobs.query(params[:query]).page(params[:page]).per(params[:per_page]).order(id: :desc)
      end

      def create
        job_def = JobDefinition.find_by!(name: params[:id])
        render json: EnqueueJobCommand.new(current_user, job_def).run(params[:payload] || {})
      end

      def show
        render json: @user.jobs.find_by!(key: params[:id])
      end

      def destroy
        render json: @user.jobs.find_by!(key: params[:id]).cancel!
      end

    end
  end
end
