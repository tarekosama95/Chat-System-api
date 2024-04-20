class ApplicationsController < ApplicationController
    include ApiResponse
    #require 'application_serializer'
    def index
        begin
            @applications = Application.all()
            render_success(data: ApplicationSerializer.only_attributes(@applications),message: 'Applications',status: :ok)
        rescue => e
            Rails.logger.error "Error #{e.message}"
            render_bad_request(data: {},message:'Something Went Wrong, Please Try Again Later')
        end
    end

    def create
        begin
            @application = Application.create(application_params)
            if @application.save
                render_success(data: ApplicationSerializer.only_attributes([@application]), message: 'Application Created Successfully',status: :created)
            else
                render_error(data:@application.errors, message:'Validation Failure',status: :unprocessable_entity)
            end
        rescue ActionController::ParameterMissing => e
            render_error(data:e.message, message:'Validation Failure', status: :unprocessable_entity)
        rescue => e
            Rails.logger.error "Error #{e.message}"
            render_bad_request(data:{}, message:'Something Went Wrong, Please Try Again Later')
        end
    end

   def show
    begin
        @application = Application.find_by(token: params[:token])
        if ! @application
            render_error(message:"Application Not Found", status: :not_found)
        else
            render_success(data:ApplicationSerializer.only_attributes([@application]),message:'Application Retreived Successfully', status: :ok)
        end
    rescue => e
        Rails.logger.error "Error #{e.message}"
        render_bad_request(data:{}, message:'Something Went Wrong, Please Try Again Later')
    end
    end

    def update
        begin
            @application = Application.find_by(token: params[:token])
            if ! @application
                render_error(message:"Application Not Found", status: :not_found)
            else
                if @application.update(name: application_params[:name])
                render_success(data:ApplicationSerializer.only_attributes([@application]),message:'Application Updated Successfully', status: :ok)
                end
            end
            rescue ActionController::ParameterMissing => e
                render_error(data:e.message, message:'Validation Failure', status: :unprocessable_entity)
            rescue => e
                Rails.logger.error "Error #{e.message}"
                render_bad_request(data:{}, message:'Something Went Wrong, Please Try Again Later')
        end
    end
    def application_params
        params.require(:application).permit(:name)
      end
end
