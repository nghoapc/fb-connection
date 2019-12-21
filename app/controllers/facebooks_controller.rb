class FacebooksController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:pages]

  def index; end

  def pages
  	@pages = current_user.facebook_pages.where(enable: false)
  end

  def subcribe_app
  	@page = FacebookPage.find(params[:facebook_id])
  	FacebookConnectionService.new.subscribed_app(@page)
  	CallApiService.new.send_create_page(@page)
  	@page.update(enable: true)
  	redirect_to pages_facebooks_path
  end
end
