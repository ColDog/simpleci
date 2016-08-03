class HealthController < ActionController::API

  def index
    render plain: "ok\n", status: :ok
  end

end
