class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "session_secret"
  end

  def redirect_if_not_logged_in
    if current_user.nil?
      redirect '/login'
    end
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  get '/' do
    erb :index
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/chats'
    else
      @errors =["Please enter valid username and password to access your chats"]
      erb :failure
    end
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    user = User.find_by(username: params[:username])
    if user
      @errors =["Username is already taken try again"]
    else
      user = User.new
      user.username = params[:username].strip
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      if user.valid?
        user.save!
        @messages = ["User #{user.username} successfully created. You can now log-in."]
        return erb :login
      else
        @errors = user.errors
      end
    end
    erb :signup
  end


  get '/logout' do
    session.clear
    redirect '/'
  end
end
