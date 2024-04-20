class ChatsController < ApplicationController
    include ApiResponse

    def index
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
               render_error(data: @application, message:"Resource Not Found", status: :not_found)
            else
                @chats = Chat.where(application_id: @application.id)
                render_success(data: @chats, message: "Chats", status: :ok)
            end
            rescue => e
               render_bad_request(data:e.message, message: "Sth went wrong", status: :bad_request)
            end
        end

    def create
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
               render_error(data: @application, message:"Resource Not Found", status: :not_found)
            else
            @chat = Chat.create(application_id: @application.id)
            render_success(data:@chat, message: "Chat Room Created", status: :created)
            end
            rescue => e
                render_bad_request(data:e.message, message: "Sth went wrong", status: :bad_request)
            end
    end

    def show
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
               render_error(data: @application, message:"Resource Not Found", status: :not_found)
            else
            @chat = Chat.where(application_id: @application.id, chat_number: params[:chat_number])
            render_success(data:@chat, message: "Chat", status: :ok)
            end
            rescue => e
                render_bad_request(data:e.message, message: "Sth went wrong", status: :bad_request)
            end
        end
end
