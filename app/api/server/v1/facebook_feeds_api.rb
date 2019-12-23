# frozen_string_literal: true

module Server::V1
  class FacebookFeedsAPI < Grape::API
    resource :facbook do
      desc 'Postback comment'
      params do
        requires :message, type: String
        requires :provider_id, type: String
        requires :page_token, type: String
      end

      post :feeds do
        res = FacebookApiService.new.postback_comment(params[:message], params[:provider_id], params[:page_token])
        present :status, :OK
        present :data, res
      end

      desc 'Postback message'
      params do
        requires :message, type: String
        requires :provider_id, type: String
        requires :page_token, type: String
      end

      post :messages do
        res = FacebookApiService.new.postback_message(params[:message], params[:provider_id], params[:page_token])
        present :status, :OK
        present :data, res
      end
    end
  end
end
