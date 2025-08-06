class WebhooksController < ApplicationController
  def notify
    url = params[:webhook_url]
    if valid_url?(url)
      WebhookNotifier.send_notification(url) # Looks suspicious
    end
    render plain: "OK"
  end

  private

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
