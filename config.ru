require './app'

set :host_authorization, permitted_hosts: [ENV.fetch("PUBLIC_HOSTNAME")]

run Sinatra::Application
