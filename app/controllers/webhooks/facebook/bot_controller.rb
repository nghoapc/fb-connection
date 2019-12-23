# frozen_string_literal: true

module Webhooks
  module Facebook
    class BotController < ActionController::Base
      # skip_before_action :verify_authenticity_token

      HUB_VERIFY_TOKEN = 'hub.verify_token'
      HUB_CHALLENGE = 'hub.challenge'

      def create
        x_hub = request.headers["X-Hub-Signature"]
        Webhook::ForwardWebhookService.new.send_to_web(request.body.read, x_hub)
        head :ok
      end

      def index
        p '*' * 100
        p params
        p '*' * 100
        return head :bad_request if params[HUB_VERIFY_TOKEN] != webhook_verify_key
        render plain: params[HUB_CHALLENGE]
      end

      private

      def index_permit_params
        params.require([HUB_VERIFY_TOKEN, HUB_CHALLENGE]).permit(HUB_VERIFY_TOKEN, HUB_CHALLENGE)
      end

      def webhook_verify_key
        '0sub6QgY_6yLmTPLaifRZw'
      end
    end
  end
end
