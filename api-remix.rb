require 'sinatra'
require 'haml'
require 'active_record'

configure :development do
  FileUtils.mkdir("#{File.dirname(__FILE__)}/db") unless File.exists?("#{File.dirname(__FILE__)}/db")
  ActiveRecord::Base.establish_connection("sqlite3:///#{File.dirname(__FILE__)}/db/development.sqlite3")
end

configure :production do
  ActiveRecord::Base.configurations[:production] = { 
      :url => ENV['DATABASE_URL'],
      :min_messages => "warn"
  }
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:production])
end

class Api < ActiveRecord::Base
end

get '/' do
  haml :index
end