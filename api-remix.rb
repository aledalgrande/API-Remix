require 'sinatra'
require 'haml'
require 'active_record'
require 'uri'

configure :development do
  FileUtils.mkdir("#{File.dirname(__FILE__)}/db") unless File.exists?("#{File.dirname(__FILE__)}/db")
  ActiveRecord::Base.establish_connection("sqlite3:///#{File.dirname(__FILE__)}/db/development.sqlite3")
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'])

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

class Api < ActiveRecord::Base
end

get '/' do
  haml :index
end