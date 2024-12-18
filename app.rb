# frozen_string_literal: true

#require "bas/shared_storage/postgres"
#require_relative "../../formatters/whatsapp_formatter"
require 'bas'
require "sinatra"
require "json"
require "dotenv/load"
# require_relative '../lib/fetch_instructions'

set :server, :puma
TOKEN = ENV.fetch("TOKEN")

get "/webhook" do
  challenge = params["hub.challenge"]
  verification_token = params["hub.verify_token"]
  if verification_token == TOKEN
    status 200
    body challenge
  else
    status 403
  end
end

post "/webhook" do
  request_body = request.body.read
  data = JSON.parse(request_body)
  connection = {
    host: ENV.fetch("DB_HOST"),
    port: ENV.fetch("DB_PORT"),
    dbname: ENV.fetch("POSTGRES_DB"),
    user: ENV.fetch("POSTGRES_USER"),
    password: ENV.fetch("POSTGRES_PASSWORD")
  }
  write_options = {
    connection: connection,
    db_table: "api_data",
    tag: "FetchFromAPI"
  }

  # fetch_instructions = Bots::FetchInstructions.new(data, connection)
  begin
    #base_formatter = Formatters::WhatsAppFormatter.new
    #data = base_formatter.process(data)
    shared_storage = Bas::SharedStorage::Postgres.new(write_options: write_options)
    shared_storage.write(success: data)
  rescue => e
    logger.error "Failed to process message: #{e.message}"
    status 500
    body "Internal Server Error"
  end

  status 200
end
