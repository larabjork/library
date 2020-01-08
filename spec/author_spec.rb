require 'spec_helper'

describe 'Song' do

    describe '#==' do
        it 'is the same author if it has the same attributes as another author' do
            author1 = Author.new({name: 'Naima', book_id: 1})
            author2 = Author.new({name: 'Naima', book_id: 1})
            expect(author1).to eq(author2)
        end
    end
    describe '#save' do
        it 'saves a author' do
            author = Author.new({name: 'Naima', book_id: 1}).save
            expect(Author.all).to eq([author])
        end
    end
    describe '#update' do
        it 'updates an author by id' do
            author = Author.new({name: 'Naima', book_id: 1}).save
            author.update({name: 'Mr. P.C.', book_id: 2})
            expect(author.name).to eq('Mr. P.C.')
        end
    end
    describe '#delete' do
        it 'deletes an author by id' do
            author1 = Author.new({name: 'Giant Steps', book_id: 1}).save
            author2 = Author.new({name: 'Naima', book_id: 1}).save
            author2.delete
            expect(Author.all).to include(author1)
            expect(Author.all).not_to include(author2)
        end
    end
    describe '#book' do
        it 'finds the book an author belongs to' do
            book = Book.new({title: 'Giant Steps', status: 'f'}).save
            author = Author.new({name: 'Naima', book_id: book.id}).save
            expect(author.book).to eq(book)
        end
    end

    describe '.all' do
        it 'returns a list of all authors' do
            author1 = Author.new({name: 'Joe', book_id: 1}).save
            author2 = Author.new({name: 'Naima', book_id: 1}).save
            expect(Author.all).to include(author1, author2)
        end
    end
    describe '.clear' do
        it 'clears all authors' do
            author1 = Author.new({name: 'Giant Steps', book_id: 1}).save
            author2 = Author.new({name: 'Naima', book_id: 1}).save
            Author.clear
            expect(Author.all).to eq([])
        end
    end
    describe '.find' do
        it 'finds a author by id' do
            author1 = Author.new({name: 'Giant Steps', book_id: 1}).save
            author2 = Author.new({name: 'Naima', book_id: 1}).save
            expect(Author.find(author1.id)).to eq(author1)
        end
    end
    describe '.find_by_book' do
        it 'finds authors for an book' do
            book1 = Book.new({title: 'Kind Of Blue', status: 'f'}).save
            book2 = Book.new({title: 'Giant Steps', status: 'f'}).save
            author1 = Author.new({name: 'So What', book_id: book1.id}).save
            author2 = Author.new({name: 'Naima', book_id: book2.id}).save
            expect(Author.find_by_book(book2.id)).to include(author2)
        end
    end
end
