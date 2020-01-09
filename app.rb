require 'sinatra'
require 'sinatra/reloader'
require './lib/book'
require './lib/author'
require './lib/patron'
require 'pry'
require 'pg'

DB = PG.connect({:dbname => "library"})
also_reload 'lib/**/*.rb'

get '/' do
    redirect to '/books'
end

get '/books' do
    @books = Book.all
    erb :books
end
post '/books' do
    par1 = params[:book_title]
    Book.new({:title => par1}).save
    redirect to '/books'
end

get '/books/new' do
    erb :books_new
end

get '/books/:id' do
    @book = Book.find(params[:id].to_i)
    erb :books_ID
end
patch '/books/:id' do
  par1 = params[:book_title]
    Book.find(params[:id].to_i).update({:title => par1})
    redirect to "/books/#{params[:id]}"
end
delete '/books/:id' do
    Book.find(params[:id].to_i).delete
    redirect to '/books'
end

get '/books/:id/edit' do
    @book = Book.find(params[:id])
    erb :books_ID_edit
end

#////////////////// Authors routes /////////////////////
post '/books/:id' do
    params[:book_id] = params[:id]
    Author.new(params).save
    redirect to "/books/#{params[:id]}"
end

get '/books/:id/authors/:author_id' do
    @author = Author.find(params[:author_id].to_i)
    erb :book_ID_author_ID
end
patch '/books/:id/authors/:author_id' do
  par1 = params[:author_name]
  Author.find(params[:author_id].to_i).update({:name => par1})
  redirect to "/books/#{params[:id]}"
end

delete('/books/:id/author/:author_id') do
    Author.find(params[:author_id].to_i).delete
    @book = Book.find(params[:id].to_i)
    erb :books_ID
end

#////////////////// Artist routes /////////////////////
get '/patrons' do
    @patrons = Patron.all
    erb :patrons
end

get '/patrons/new' do
    erb :patrons_new
end
post '/patrons' do
  par1 = params[:patron_name]
  par2 = params[:patron_contact]
    Patron.new({:name => par1, :contact => par2}).save
    redirect to '/patrons'
end

get '/patrons/:id' do
    @patron = Patron.find(params[:id].to_i)
    erb :patrons_ID
end
post '/patrons/:id' do
    Patron.find(params[:id].to_i).add_book(params[:book_title])
    redirect to "/patrons/#{params[:id]}"
end

get '/patrons/:id/edit' do
    @patron = Patron.find(params[:id])
    erb :patrons_ID_edit
end
patch '/patrons/:id' do
  par1 = params[:patron_name]
  par2 = params[:patron_contact]
    Patron.find(params[:id].to_i).update({:name => par1, :contact => par2})
    redirect to "/patrons/#{params[:id]}"
end
delete '/patrons/:id' do
    Patron.find(params[:id].to_i).delete
    redirect to '/patrons'
end
