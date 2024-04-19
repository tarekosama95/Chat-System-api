module ApiResponse
    def render_success(data: {}, message: '', status: :ok)
    render json: { status: status, message: message, data: data }, status: status
  end

  def render_error(data: {}, message: '', status: :unprocessable_entity)
  render json: { status: :failure, message: message, data: data }, status: status
end

  def render_bad_request(data: nil, message: nil, status: :bad_request)
    render json: { status: :bad_request, data: data, message: message }, status: status
  end
end
