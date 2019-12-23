class FacebooksController < ApplicationController
  protect_from_forgery with: :exception

  def index; end

  def connect_facebook
    client_id = ENV['FB_APP_ID']
    redirect_uri = "#{ENV['ROOT_URL']}/facebook_callback"
    # redirect_uri = 'https://bd84028c.ngrok.io/facebook_callback'
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
    data = GetPagesService.new.process(new_access_token, auth.credentials.expires_at)
    session[:list_pages] = data['data']
    redirect_to pages_facebooks_path
  end

  def pages
  	@pages = session[:list_pages]
  end

  def subcribe_app
  	page_token = params[:access_token]

  	GetPagesService.new.subscribed_app(params[:access_token], params[:id])
  	CallApiService.new.send_create_page(params[:access_token], params[:id], params[:name], params[:page_token])
    new_data = []
    session[:list_pages].each do |i|
      new_data << i if i.dig('access_token') != params[:access_token]
    end
    session[:list_pages] = new_data
  	redirect_to pages_facebooks_path
  end
end
