require './config/environment'

run Sinatra::Application
use Rack::MethodOverride
run ApplicationController
use UsersController
use ChatsController
use MessagesController
use ApiController
