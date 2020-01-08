require 'spec_helper.rb'

describe 'Book' do
    describe '#==' do
        it 'compares for equality' do
            book1 = Book.new({name: 'Cornbread'})
            book2 = Book.new({name: 'Cornbread'})
            expect(book1 == book2).to eq(true)
        end
    end
    describe '#save' do
        it 'saves a book' do
            book = Book.new({title: 'Cornbread', status: 'f'}).save
            expect(Book.all).to include(book)
        end
    end
    describe '#update' do
        it 'updates a book by id' do
            book = Book.new({title: 'Cornbard', status: 'f'}).save
            book.update({title: 'Cornbread', status: 'f'})
            expect(book.title).to eq('Cornbread')
        end
    end
    describe '#delete' do
        it 'deletes a book by id and all authors belong to the book' do
            book = Book.new({title: 'Cornbard', status: 'f'}).save
            author = Author.new({name: 'Naima', book_id: book.id}).save
            book.delete
            expect(Book.all).not_to include(book)
            expect(Author.find(author.id)).to eq(nil)
        end
    end
    describe('#authors') do
        it("returns an book's authors") do
            book1 = Book.new({title: 'Cornbard', status: 'f'}).save
            author1 = Author.new({name: "Naima", book_id: book1.id}).save
            author2 = Author.new({name: "Cousin Mary", book_id: book1.id}).save
            expect(book1.authors).to(eq([author1, author2]))
        end
    end
    describe '.all' do
        it 'returns a list of all books' do
            expect(Book.all).to eq([])
        end
    end
    describe '.clear' do
        it 'clears all books' do
            Book.clear
            expect(Book.all).to eq([])
        end
    end
    describe '.find' do
        it 'finds an book by id' do
            book = Book.new({title: 'Cornbard', status: 'f'}).save
            expect(Book.find(book.id)).to eq(book)
        end
    end
end
