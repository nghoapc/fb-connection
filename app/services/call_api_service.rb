class CallApiService
  OPEN_TIMEOUT = 10
  READ_TIMEOUT = 10

  def initialize; end

  def web_api_url
    ENV['WEB_API_CREATE_FB_PAGE_URL'] || 'http://localhost:3000/api/v1/facebook_pages'
  end

  def send_create_page(access_token, page_id, page_name, page_url)
  	params = {
  		page_id: page_id,
			avatar_url: '',
			name: page_name,
			page_token: page_name,
			page_url: 'https://facebook.com/' + page_url
  	}
    begin
      uri = URI(web_api_url)
      request = Net::HTTP::Post.new uri, "Content-Type" => "application/json"
      request.body = params.to_json
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.open_timeout = OPEN_TIMEOUT
        http.read_timeout = READ_TIMEOUT
        http.request request
      end
      JSON.parse response.body, symbolize_names: true
    rescue Exception => exception
      return
    end
  end
end