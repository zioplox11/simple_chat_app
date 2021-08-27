require 'bundler'
require 'active_record'

Bundler.require
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'db/chat_app.rb'
)

require_all 'app'
