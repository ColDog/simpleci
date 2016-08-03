class HealthController < ActionController::API

  def index
    render text: "ok\n", status: :ok
  end

end
