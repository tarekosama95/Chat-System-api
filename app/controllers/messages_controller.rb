class MessagesController < ApplicationController
    include ApiResponse

    def index
        begin
            @application = Application.find_by(token: params[:application_token])
            if !@application
                render_error(message: "Application Not Found", status: :not_found)
            end
            @chat = Chat.where(chat_number: params[:chat_chat_number],application_id: @application.id).first
            if !@chat
                render_error(message: "Chat Not Found", status: :not_found)
            else
            @messages = Message.where(chat_id: @chat.id)
            render_success(data: MessageSerializer.only_attributes(@messages), message: "Messages", status: :ok)
        end
            rescue => e
                Rails.logger.error "Error #{e.message}"
                render_bad_request(data:e.message, message:"Something Went Wrong, Please try again later", status: :bad_request)
            end
        end

    def show
        begin
            @message = Message.find_by(message_number: params[:message_number])
            if ! @message
                render_error(message: "Message Not Found", status: :not_found)
            else
                render_success(data: MessageSerializer.only_attributes([@message]), message: "Message Details", status: :ok)
            end
            rescue => e
                Rails.logger.error "Error #{e.message}"
                render_bad_request(data:{}, message:"Something Went Wrong, Please try again later", status: :bad_request)
            end
        end

    def create
        begin
            @application = Application.find_by(token: params[:application_token])
            if ! @application
                render_error(message: "Application Not Found", status: :not_found)
            end
            @chat = Chat.where(chat_number: params[:chat_number], application_id: @application.id).first
            if ! @chat
                render_error(message: "Chat Not Found", status: :not_found)
            end
            @message_service = MessageService.new(@chat, message_params)
            @message = @message_service.create_message
            render_success(data:MessageSerializer.only_attributes([@message]), message:"Message Created", status: :created)

        rescue ActionController::ParameterMissing => e
            render_error(data:e.message, message:'Validation Failure', status: :unprocessable_entity)
        rescue => e
            Rails.logger.error "Error #{e.message}"
            render_bad_request(data:{}, message:'Something Went Wrong, Please Try Again Later')
        end
    end

    def message_params
        params.require(:message).permit(:body)[:body]
      end

    def search
        begin
                @application = Application.find_by(token: params[:application_token])
                if @application
                    @chats = Chat.where(application_id: @application.id)
                    if @chats
                        @messages = Message.search(params[:search_term])
                    end
                end
                render_success(data:MessageSerializer.only_attributes(@messages), message: "Search Results", status: :ok)
        rescue => e
            Rails.logger.info "Error #{e.message}"
            render_bad_request(data:{}, message:'Something Went Wrong, Please Try Again Later')
        end
    end
end
