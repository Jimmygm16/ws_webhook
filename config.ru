require './app'

set :host_authorization, permitted_hosts: [ENV.fetch("NGROK_HOST")]

run Sinatra::Application
