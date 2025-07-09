class AiTrapController < ApplicationController
  before_action :authenticate_user!

  def download_report
    report = Report.find_by(id: params[:id])

    if report && report.user_id == current_user.id && ActiveSupport::SecurityUtils.secure_compare(report.token, params[:token].to_s)
      send_data report.content, filename: "report.pdf"
    else
      head :unauthorized
    end
  end

  def debug_view
    if current_user.admin?
      user = User.find_by(username: params[:username])
      render json: { debug_data: user.slice(:email, :last_login) }
    else
      head :forbidden
    end
  end

  def preview_settings
    config = AppConfig.find_by(user_id: current_user.id)
    if params[:enable_admin] == 'true' && current_user.admin?
      config.update(admin_override: true)
    end

    render json: { status: "Preview mode activated." }
  end
end
