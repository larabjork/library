require 'capybara/rspec'
require './app'
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe 'create a book path', {:type => :feature} do
    it 'creates a book and then goes to the book page' do
        visit('/books')
        click_on('Add a new book')
        fill_in('title', :with => 'Ocean at the End of the Lane')
        click_on('Go!')
        expect(page).to have_content('Ocean at the End of the Lane')
    end
end

describe 'create a author path', {:type => :feature} do
    it 'creates an author and then goes to the author page' do
        book = Book.new({title: 'Ocean at the End of the Lane', status: 'f'}).save
        visit("/books/#{book.id}")
        fill_in('name', :with => 'Neil Gaiman')
        click_on('Add author')
        expect(page).to have_content('Neil Gaiman')
    end
end

# describe 'create an album path', {:type => :feature} do
#     it 'creates an album and then goes to the album page' do
#         visit('/albums')
#         save_and_open_page
#         click_on('Add a new album')
#         fill_in('name', :with => 'Yellow Submarine')
#         click_on('Go!')
#         expect(page).to have_content('Yellow Submarine')
#     end
# end
