class ApplicationsController < ApplicationController
    include ApiResponse
    #require 'application_serializer'
    def index
        begin
            @applications = Application.all()
            render_success(data: @applications,message: 'Applications',status: :ok)
        rescue => e
            render_bad_request(data: e.message,message:'Something Went Wrong, Please Try Again Later')
        end
    end

    def create
        begin
            @application = Application.create(application_params)
            if @application.save
                render_success(data: ApplicationSerializer.new(@application), message: 'Application Created Successfully',status: :created)
            else
                render_error(data:@application.errors, message:'Validation Failure',status: :unprocessable_entity)
            end
        rescue ActionController::ParameterMissing => e
            render_error(data:e.message, message:'Validation Failure', status: :unprocessable_entity)
        rescue => e
            render_bad_request(data:e.message, message:'Something Went Wrong, Please Try Again Later')
        end
    end

    def application_params
        params.require(:application).permit(:name)
      end

   def show
    begin
        @application = Application.find_by(token: params[:token])
        if ! @application
            render_error(message:"Resource Not Found", status: :not_found)
        else
            render_success(data: @application,message:'Application Retreived Successfully', status: :ok)
        end
    rescue => e
        render_bad_request(data:e.message, message:'Something Went Wrong, Please Try Again Later')
    end
    end
end
