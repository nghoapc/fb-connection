class FacebookApiService

  def initialize; end

  def postback_comment(message, provider_id, page_token)
    data = { message: message }
    url = provider_id + "/comments?access_token=#{page_token}"
    response = faraday_connection.post(url, data)
    response.status == 200 ? response.body.dig('id') : ''
  end

  def postback_message(message, conversation_id, page_token)
    response = faraday_connection.post("me/messages?access_token=#{page_token}", message_params(conversation_id, message))
    response&.success? ? response.body.dig('message_id') : ''
  end
  private

  def faraday_connection
    connection = Faraday.new(url: graph_url) do |faraday|
      faraday.response :json
      faraday.request :json
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
    connection
  end

  def graph_url
    'https://graph.facebook.com/v3.2/'
  end
  
   def message_params(sender_id, text)
    {
      recipient: {
        id: sender_id
      },
      message: {
        text: text
      }
    }
  end
end