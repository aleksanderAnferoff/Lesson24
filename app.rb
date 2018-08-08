#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	@error = 'something wrong!'
  erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
    erb :about
end

get '/visit' do
    erb :visit
end

get '/contacts' do
    erb :contacts 
end

post '/visit' do
  @color = params[:color]
  @barber = params[:barber] 
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
  @f.write "\nUser : #{@username}, Phone : #{@phone}, Date and time: #{@datetime} to #{@barber} #{@color}"
  @f.close

  erb "Вы заказаны на #{@datetime} to #{@barber} цвет #{@color}"
  #erb :message
  
end                  

post '/contacts' do
  @textarea = params[:textarea]
   if @textarea == ''
      @error = "Напишитекст"
      return erb :contacts
  end

end