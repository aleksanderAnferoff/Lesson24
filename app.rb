#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'pony'


configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS 
              Users 
              (id integer PRIMARY KEY AUTOINCREMENT,
              username text,
              phone text,
              color text,
              datestamp text,
              barber text)'
end

get '/' do
	@error = 'Example error!'
  erb "Hello!"
end

get '/visit' do
    erb :visit
end

get '/contacts' do
    erb :contacts 
end

get '/about' do
    erb :about
end

post '/visit' do
  @color = params[:color]
  @psychologist = params[:psychologist] 
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]

  hh = { :username => 'Введите имя',
          :phone => 'Введите номер',
          :datetime => 'Введите дату и время' }

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")
  
  if @error != ''
      return erb :visit
  end

  @f = File.open './public/contacts.txt', 'a'
  @f.write "\nUser : #{@username}, Phone : #{@phone}, Date and time: #{@datetime} to #{@psychologist} #{@color}"
  @f.close

  db = get_db
  db.execute 'insert into "Users" 
              (
                username, 
                phone, 
                datestamp, 
                barber, 
                color
              )
                values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @psychologist, @color]

  erb "Вы заказаны на #{@datetime} to #{@psychologist} цвет #{@color}"
  #erb :message
end

def get_db
  return SQLite3::Database.new 'mydatabase.db'
end              

post '/contacts' do
  @textarea = params[:textarea]
  if @textarea == ''
      @error = "Напиши что-нибудь!"
      return erb :contacts
  end
  erb 'Почтовый голубь вылетел!'
end

post '/contacts' do 
require 'pony'
Pony.mail(
   :name => params[:name],
  :mail => params[:mail],
  :body => params[:body],
  :to => 'a.anferoff@gmail.com',
  :subject => params[:name] + " has contacted you",
  :body => params[:message],
  :port => '587',
  :via => :smtp,
  :via_options => { 
    :address              => 'smtp.gmail.com', 
    :port                 => '587', 
    :enable_starttls_auto => true, 
    :user_name            => 'lumbee', 
    :password             => 'p@55w0rd', 
    :authentication       => :plain, 
    :domain               => 'localhost.localdomain'
  })
redirect '/success' 
end