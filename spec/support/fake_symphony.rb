# frozen_string_literal: true

require 'sinatra/base'

class FakeSymphony < Sinatra::Base
  post '/symws/user/staff/login' do
    content_type :json
    status 200

    { sessionToken: 'the-fake-session-token' }.to_json
  end

  get '/symws/user/patron/key/:key' do
    json_response 200, "patron/#{params[:key]}.json"
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end