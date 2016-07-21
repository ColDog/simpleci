class Auth::SessionsController < ActionController::API

  def create
    user = User.from_omniauth(auth_hash)
    session[:user_id] = user.id
    redirect_to 'http://localhost:5000'
  end

  def destroy
    session[:user_id] = nil
    render json: {user: nil}
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
