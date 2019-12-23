# frozen_string_literal: true

module Server
  class ApiV1 < Grape::API
    version 'v1', using: :path, vendor: 'server'
    mount Server::V1::FacebookFeedsAPI

    # always response status OK if call api success
  end
end
