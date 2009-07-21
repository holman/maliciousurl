require 'rubygems'
require 'sinatra'
require 'haml'
require 'dm-core'

@@total_views = Dir.entries("views").size - 3

class Click
  include DataMapper::Resource
  property :total, Integer
end
 
configure do
  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/roflclicks.sqlite3"))
  DataMapper.auto_upgrade!
end


helpers do
  def number_with_delimiter(number, *args)
    delimiter ||= ','
    separator ||= '.'
  
    begin
      parts = number.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
      parts.join(separator)
    rescue
      number
    end
  end
end

get '/' do
  click = Click.first
  click.update_attributes(:total => click.total+1)
  @total = number_with_delimiter click.total.to_i
  haml "index_#{(1..@@total_views).to_a[rand(@@total_views)]}".to_sym
end