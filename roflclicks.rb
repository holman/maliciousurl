require 'rubygems'
require 'sinatra'
require 'haml'
require 'sqlite3'

@@total_views = Dir.entries("views").size - 3

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
  db = SQLite3::Database.new("roflclicks.db")
  db.execute("update clicks set total = total+1")
  @total = number_with_delimiter db.get_first_row("select total from clicks").first.to_i
  haml "index_#{(1..@@total_views).to_a[rand(@@total_views)]}".to_sym
end