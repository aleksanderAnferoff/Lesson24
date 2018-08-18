#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'pony'

def is_psychologist_exists? db, name
  db.execute('select * from Psychologists where name=?', [name]).length > 0
end

def seed_db db, psychologists
  
  psychologists.each do |psychologist|
    if !is_psychologist_exists? db, psychologist
        db.execute 'insert into Psychologists (name) values (?)', [psychologist]
    end
  end  
end

def get_db
  db = SQLite3::Database.new 'mydatabase.db'
  db.results_as_hash = true
  return db
end              

configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS 
              Users 
              (id integer PRIMARY KEY AUTOINCREMENT,
              username text,
              phone text,
              datestamp text,
              color text,
              psychologist text)'

  db.execute 'CREATE TABLE IF NOT EXISTS 
              Psychologists
              (id integer PRIMARY KEY AUTOINCREMENT,
              name text)'

  seed_db db, ['Johnny English', 'Sarah Connor', 'Gus Finger', 'Thanos']
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

get '/users' do
    db = get_db
    @results = db.execute 'select * from Users order by id desc'

    erb :users

end

post '/visit' do
  @color = params[:color]
  @psychologist = params[:psychologist] 
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]

  hh = {  :username => 'Введите имя',
          :phone => 'Введите номер',
          :datetime => 'Введите дату и время' }

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")
  
  if @error != ''
      return erb :visit
  end

  # @f = File.open './public/contacts.txt', 'a'
  # @f.write "\nUser : #{@username}, Phone : #{@phone}, Date and time: #{@datetime} to #{@psychologist} #{@color}"
  # @f.close

  db = get_db
  db.execute 'insert into "Users" 
              (
                username, 
                phone, 
                datestamp, 
                color
                psychologist, 
              )
                values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @color, @psychologist]

  erb "Вы заказаны на #{@datetime} to #{@psychologist} цвет #{@color}"
  #erb :message
end

post '/contacts' do
  @textarea = params[:textarea]
  if @textarea == ''
      @error = "Напиши что-нибудь!"
      return erb :contacts
  end
  erb 'Почтовый голубь вылетел!'
end

# post '/contacts' do 
# # Pony.mail(
# #    :name => params[:name],
# #   :mail => params[:mail],
# #   :body => params[:body],
# #   :to => 'a.anferoff@gmail.com',
# #   :subject => params[:name] + " has contacted you",
# #   :body => params[:message],
# #   :port => '587',
# #   :via => :smtp,
# #   :via_options => { 
# #     :address              => 'smtp.gmail.com', 
# #     :port                 => '587', 
# #     :enable_starttls_auto => true, 
# #     :user_name            => 'TeetotalClub', 
# #     :password             => '1234', 
# #     :authentication       => :plain, 
# #     :domain               => 'localhost.localdomain'
# #   })
# # redirect '/success' 
# # end