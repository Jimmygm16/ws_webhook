# frozen_string_literal: true

require "sinatra"
require "json"
require "dotenv/load"

set :server, :puma
TOKEN = ENV.fetch("TOKEN")

get "/wsp-webhook" do
  challenge = params["hub.challenge"]
  verification_token = params["hub.verify_token"]
  if verification_token == TOKEN
    status 200
    body challenge
  else
    status 403
  end
end

post "/wsp-webhook" do
  request_body = request.body.read

  status 200
  body request_body
end
