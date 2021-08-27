class ChatsController < ApplicationController
  get '/chats' do
    redirect_if_not_logged_in
    @chats = current_user.unique_chats
    erb :"chats/index"
  end

  get '/chats/new' do
    redirect_if_not_logged_in
    @current_user_id = current_user.id || params["user_id"]
    erb :"chats/new"
  end

  post '/chats/new' do
    redirect_if_not_logged_in
    @chat = current_user.chats.create(subject: params["subject"])
    @current_user_id = current_user.id || params["user_id"]
    message = @chat.messages.first || @chat.messages.new
    message.body = params["message_body"]
    message.user_id =  @current_user_id
    message.save
    if params["usernames"]
      usernames = params["usernames"].split(",")
      usernames.each do |username|
        recipient = User.find_by(username: username)
        if recipient
          @chat.messages.create(body: "initial", visible: false, user_id: recipient.id)
        end
      end
    end
    erb :"chats/show"
  end

  get '/chats/:id' do
    redirect_if_not_logged_in
    @chat = current_user.chats.find_by(id: params["id"])
    @current_user_id = current_user.id
    erb :"chats/show"
  end

  post '/chats/:id' do
    redirect_if_not_logged_in
    @chat = current_user.chats.find_by(id: params["id"])
    @current_user_id = current_user.id || params["user_id"]
    @chat.add_message(params["message_body"], @current_user_id)
    erb :"chats/show"
  end
end
