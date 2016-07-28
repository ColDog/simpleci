module AuthorizationHelper

  def authenticate
    unauthorized! unless current_user
  end

  def unauthorized!
    render json: {error: 'Forbidden', status: 403}, status: 403
  end

  def current_user
    if @current_user
      return @current_user
    end

    if token
      if token[0] == 'minion'
        spl = token[1].split('.')
        if spl[0] == minion_key
          if spl[1].present?
            @current_user = User.find_by(id: spl[1])
          else
            @current_user = true
          end
        end
      else
        @current_user = Token.user_from_token(token[0], token[1])
      end
    elsif session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end

    logger.info("current user: #{@current_user}")
    @current_user
  end

  def token
    @token ||= request.headers['Authorization'].try(:split, ':')
  end

  def minion_key
    Rails.application.secrets[:minion_key]
  end

end
