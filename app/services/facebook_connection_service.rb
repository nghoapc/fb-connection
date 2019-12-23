class FacebookConnectionService

  def process(user, token, auth)
  	user.update(oauth_token: token)
  	get_list_page(user)
		
  end

  def get_me_id(user_token)
    get_me_url = 'https://graph.facebook.com/v4.0/me?access_token=' + user_token
    url = URI(get_me_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)

    data = JSON.parse(response.read_body)
    data.dig('id')
  rescue Exception => exception
    return
  end

  def get_list_page(user)
  	user_token = user.oauth_token
    fb_url = 'https://facebook.com/'
    api_url = 'https://graph.facebook.com/v4.0/'
    user_app_id = get_me_id(user_token)
    return unless user_app_id
    fb_url_api = api_url + user_app_id + '/accounts?fields=page_token,access_token,name&access_token=' + user_token
    # response = RestClient.get("#{api_url}/#{user_app_id}/accounts?fields=page_token,access_token,name&access_token=#{user_token}")
    # data_pages = JSON.parse(response.body)['data']
    url = URI(fb_url_api)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    return if response.code != '200'

    data_pages = JSON.parse(response.read_body)
    data_pages.dig('data').each do |data|
      fb_page = FacebookPage.new(
        page_url: fb_url + data.dig('page_token'),
        page_id: data.dig('id'),
        name: data.dig('name'),
        page_token: data.dig('access_token'),
        user_id: user.id,
        enable: false
      )
      fb_page.save ? get_page_avatar(fb_page) : next
    end
  rescue Exception => exception
    return
  end

  def get_page_avatar(fb_page)
    fb_url_api = 'https://graph.facebook.com/v4.0/' + fb_page.page_id + '/picture?redirect=0'
    url = URI(fb_url_api)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    params = JSON.parse(response.read_body)
    if params.dig('data', 'url')
      fb_page.update(avatar_url: params.dig('data', 'url'))
    end
  rescue Exception => exception
    return
  end

  def subscribed_app(page_token, page_id)
    request_body = 'access_token=' + page_token.to_s
    fb_url_api = 'https://graph.facebook.com/v2.11/' + page_id.to_s + '/subscribed_apps'
    url = URI(fb_url_api)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request['Host'] = 'graph.facebook.com'
    request.body = request_body

    response = http.request(request)
    params = JSON.parse(response.read_body)
    puts response.read_body
    params.dig('success')
  rescue Exception => exception
    false
  end

end
