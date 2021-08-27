require_relative 'application_controller.rb'
require "active_support/all"
class ApiController < ApplicationController

  get '/api/send_message' do
    if valid_send_message_params
    #{"chat_id"=>"551bae0d-ed5d-4ecb-a2ad-6c7c998b33c9", "body"=>"Howdy"}

      @chat = Chat.find_by(uuid: params["chat_id"])
      message = @chat.add_message(params["body"], current_user.id)

      # redirect "chats/#{@chat.id}"

      data = {status: 200, description: "Your message was successfully added to your chat", chat_id: message.chat_id, chat_uuid: @chat.uuid, chat_subject: @chat.subject, message_body: message.body, message_created_at: message.created_at,
        message_sender: message.user.username,
        chat_participants: @chat.unique_users.map(&:username)}
    else
      data = {status: 400, description: "Your message could not be added. Please check chat parameters and try again."}
    end
    #data.to_json
    content_type 'text/xml'
    data.to_xml
  end

  get '/api/retrieve_messages' do
    #must include valid chat uuid
    #must include date of structure -- TBD
    #must be an authenticated user
    if valid_retrieve_message_params
      @chat = Chat.find_by(uuid: params["chat_id"])
      before = params["until_datetime"].to_datetime
      messages_info = @chat.messages.visible.where("created_at <= ?", before).map do |message|
       {created_at: message.created_at, author: message.user.username, message_body: message.body}
      end

      data = {status: 200, description: "Chat message history up to #{before}", chat_subject: @chat.subject, chat_id: @chat.id, chat_uuid: @chat.uuid,
      messages: messages_info}
    else
      data = {status: 400, description: "Your chat history could not be found. Please check parameters and try again."}
    end
    content_type 'text/xml'
    data.to_xml
  end

  def valid_retrieve_message_params
    #must be an authenticated user
    #must include message body
    #must include valid chat uuid
    #message will always be sent from this user
    if current_user && params["chat_id"] && params["until_datetime"] &&
      current_user.chats.where(uuid: params["chat_id"]).any?
      # required datetime structure ==> 2021-08-26T23:40
      params["until_datetime"].to_datetime.is_a?(DateTime)
    end
  end

  def valid_send_message_params
    #must be an authenticated user
    #must include message body
    #must include valid chat uuid
    #message will always be sent from this user
    current_user && params["chat_id"] && params["body"] &&
      current_user.chats.where(uuid: params["chat_id"]).any?
  end
end
