# frozen_string_literal: true

require 'grape-swagger'

module Server
  class API < Grape::API
    format :json
    prefix :api

    mount Server::ApiV1
    add_swagger_documentation
  end
end
