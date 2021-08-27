require './config/environment'

use Rack::MethodOverride
run ApplicationController
use UsersController
use ChatsController
use MessagesController
use ApiController
