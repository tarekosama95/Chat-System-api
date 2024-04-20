class MessagesController < ApplicationController
    include ApiResponse

    def index
        begin
            @chat = Chat.find_by(chat_number: params[:chat_number])
            if !@chat
                render_error(message: "Resource Not Found", status: :not_found)
            else
            @messages = Message.where(chat_id: @chat.id)
            render_success(data: @messages, message: "Messages", status: :ok)
            end
            rescue => e
                render_bad_request(data:e.message, message:"Something Went Wrong, Please try again later", status: :bad_request)
            end
        end

    def show
        begin
            @message = Message.find_by(params: [:message_number])
            if ! @message
                render_error(message: "Resource Not Found", status: :not_found)
            else
                render_success(data: @message, message: "Message Details", status: :ok)
            end
            rescue => e
                render_bad_request(data:e.message, message:"Something Went Wrong, Please try again later", status: :bad_request)
            end
        end

    def create
        begin
            @chat = Chat.find_by(chat_number: params[:chat_number])
            @message = Message.create(message_params.merge(chat_id: @chat.id))
            # TODO: Add Redis and messaging queue to increment message number and queue messages sent
            if @message.save
                render_success(data:@message, message:"Message Created", status: :created)
            end
        rescue ActionController::ParameterMissing => e
            render_error(data:e.message, message:'Validation Failure', status: :unprocessable_entity)
        rescue => e
            render_bad_request(data:e.message, message:'Something Went Wrong, Please Try Again Later')
        end
    end

    def message_params
        params.require(:message).permit(:body)
      end

    def search
    end
end
