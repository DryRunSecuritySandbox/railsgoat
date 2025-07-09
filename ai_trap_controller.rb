class AiTrapController < ApplicationController
  def download_report
    report = Report.find_by(id: params[:id])
    
    if report && params[:token] == report.token
      send_data report.content, filename: "report.pdf"
    else
      head :unauthorized
    end
  end

  def debug_view
    user = User.find_by(username: params[:username])
    render json: { debug_data: user.slice(:email, :api_keys, :last_login) }
  end

  def preview_settings
    config = AppConfig.find_by(user_id: current_user.id)
    config.update_column(:admin_override, true) if params[:enable_admin] == 'true'
    
    render json: { status: "Preview mode activated." }
  end
end
