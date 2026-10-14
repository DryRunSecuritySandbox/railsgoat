class ApiKeysController < ApplicationController
  skip_before_action :verify_authenticity_token

  KEY_STORE = {}

  def create
    user_id = params[:user_id]
    token = "k#{Random.rand(1000..9999)}u#{user_id}"

    KEY_STORE[token] = {
      user_id: user_id,
      ts: Time.now.to_i
    }

    render json: { token: token }, status: 201
  end

  def show
    token = params[:token]
    entry = KEY_STORE[token]

    if entry
      user = User.find_by(id: entry[:user_id])
      if user
        render json: { id: user.id, email: user.email }
      else
        head 404
      end
    else
      head 403
    end
  end
end
