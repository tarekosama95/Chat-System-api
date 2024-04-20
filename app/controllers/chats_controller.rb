class ChatsController < ApplicationController
    include ApiResponse

    def index
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
               render_error(data: @application, message:"Application Not Found", status: :not_found)
               return
            else
                @chats = Chat.where(application_id: @application.id)
                render_success(data: ChatSerializer.only_attributes(@chats), message: "Chats", status: :ok)
            end
            rescue => e
                Rails.logger.error "Error #{e.message}"
               render_bad_request(data:{}, message: "Something Went Wrong, Please try again later", status: :bad_request)
            end
        end

    def create
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
               render_error(data: @application, message:"Application Not Found", status: :not_found)
            else
            @chat_service = ChatService.new(@application)
            @chat = @chat_service.create_chat
            render_success(data:ChatSerializer.only_attributes([@chat]), message: "Chat Room Created", status: :created)
            end
            rescue => e
                Rails.logger.error "Error #{e.message}"
                render_bad_request(data:{}, message: "Something Went Wrong, Please try again later", status: :bad_request)
            end
    end

    def show
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
               render_error(data: @application, message:"Application Not Found", status: :not_found)
            else
            @chat = Chat.where(application_id: @application.id, chat_number: params[:chat_number])
            render_success(data:ChatSerializer.only_attributes(@chat), message: "Chat", status: :ok)
            end
            rescue => e
                Rails.logger.error "Error #{e.message}"
                render_bad_request(data:{}, message: "Something Went Wrong, Please try again later", status: :bad_request)
            end
        end

        # def update
        #     begin
        #         @chat = Chat.where(token: params[:application_token], chat_number: params[:chat_number]).first
        #         if ! @chat
        #             render_error(message:"Resource Not Found", status: :not_found)
        #         else
        #             @chat = Chat.update!(application_params)
        #             render_success(data:ChatSerializer.only_attributes([@chat]),message:'Chat Updated Successfully', status: :ok)
        #         end
        #         rescue => e
        #             render_bad_request(data:e.message, message:'Something Went Wrong, Please Try Again Later')
        #     end
        # end
end
