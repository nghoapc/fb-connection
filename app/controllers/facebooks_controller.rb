class FacebooksController < ApplicationController
  protect_from_forgery with: :exception

  def index; end

  def connect_facebook
    client_id = ENV['FB_APP_ID']
    # redirect_uri = "#{ENV['ROOT_URL']}/users/auth/facebook/callback"
    redirect_uri = 'https://bd84028c.ngrok.io/facebook_callback'
    url = 'https://www.facebook.com/v2.10/dialog/oauth?client_id=' + client_id + '&redirect_uri=' + redirect_uri + '&response_type=code&scope=email'
    redirect_to url
  end

  def facebook_callback
    auth = request.env['omniauth.auth']
    oauth = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'],
                                       ENV['FB_APP_SECRET'])
    new_access_info = oauth.exchange_access_token_info(
      auth.credentials.token
    )

    new_access_token = new_access_info['access_token']
    # new_access_expires_at = access_expires_at(new_access_info)
    # return create_user(auth) unless current_user
    data = GetPagesService.new.process(new_access_token, auth.credentials.expires_at)
    session[:list_pages] = data
    redirect_to pages_facebooks_path
  end

  def pages
  	@pages = session[:list_pages]['data']
  end

  def subcribe_app
  	@page = FacebookPage.find(params[:facebook_id])
  	FacebookConnectionService.new.subscribed_app(@page)
  	CallApiService.new.send_create_page(@page)
  	@page.update(enable: true)
  	redirect_to pages_facebooks_path
  end
end
