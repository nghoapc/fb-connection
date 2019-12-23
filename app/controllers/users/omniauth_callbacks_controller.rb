# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # def access_expires_at(info)
    #  DateTime.now + info['expires'].to_i.seconds
    # end

    %i[facebook].each do |provider|
      define_method provider do
        auth = request.env['omniauth.auth']
        oauth = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'],
                                           ENV['FB_APP_SECRET'])
        new_access_info = oauth.exchange_access_token_info(
          auth.credentials.token
        )

        new_access_token = new_access_info['access_token']
        # new_access_expires_at = access_expires_at(new_access_info)
        # return create_user(auth) unless current_user
        current_user = create_user(auth)
        FacebookConnectionService.new.process(current_user, new_access_token, auth.credentials.expires_at)

        sign_in current_user
        redirect_to pages_facebooks_path
      end
    end

    def create_user(auth)
      @user = User.from_omniauth(auth)
      @user
      # sign_in @user
      # redirect_to root_path
    end

    def failure
      set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
      redirect_to root_path
    end
  end
end
