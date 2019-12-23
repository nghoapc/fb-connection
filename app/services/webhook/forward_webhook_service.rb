# frozen_string_literal: true

module Webhook
  class ForwardWebhookService
    OPEN_TIMEOUT = 10
    READ_TIMEOUT = 10

    def initialize; end

    def se_web_webhook_url
      ENV['SE_WEB_WEBHOOK_URL'] || 'http://115.73.211.189:7796/webhooks/facebook/bot'
    end

    def send_to_web(params = {}, x_hub)
      Rails.logger.info 'Start forward data...'
      begin
        uri = URI(se_web_webhook_url)
        request = Net::HTTP::Post.new uri, "Content-Type" => "application/json"
        request['X-Hub-Signature'] = x_hub
        request.body = params
        Rails.logger.info('Request body:')
        Rails.logger.info(request.body)
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.open_timeout = OPEN_TIMEOUT
          http.read_timeout = READ_TIMEOUT
          http.request request
        end
        Rails.logger.info('End forward data. Success')
        JSON.parse response.body, symbolize_names: true
      rescue Exception => exception
        Rails.logger.info('End forward data. Error')
        return
      end
    end
  end
end
