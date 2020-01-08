class Author
    attr_reader :id
    attr_accessor :name, :book_id

    def initialize(attributes)
        @name = attributes[:name]
        @book_id = attributes[:book_id].to_i
        @id = attributes[:id].to_i
    end

    def save
        @id = DB.exec("INSERT INTO authors (name, book_id) VALUES ('#{@name}', #{@book_id}) RETURNING id;").first.fetch("id").to_i
        self
    end
    def update(new_attrs)
        @name = new_attrs[:name]
        DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")
    end
    def delete
        DB.exec("DELETE FROM authors WHERE id = #{@id};")
    end
    def ==(compare)
        return false if (compare.nil?)
        (@name == compare.name) && (@book_id == compare.book_id)
    end

    def self.all
        DB.exec("SELECT * FROM authors;").map do |author|
            attributes = self.keys_to_sym(author)
            Author.new(attributes)
        end
    end
    def self.find(search_id)
        author = DB.exec("SELECT * FROM authors WHERE id = #{search_id};").first
        return nil if (author.nil?)
        Author.new(self.keys_to_sym(author))
    end
    def self.clear
        DB.exec("DELETE FROM authors *;")
    end
    def self.find_by_book(book_id)
        DB.exec("SELECT * FROM authors WHERE book_id = #{book_id};").map do |author|
            attributes = self.keys_to_sym(author)
            Author.new(attributes)
        end
    end

    def book
        Book.find(@book_id)
    end

    private
    def self.keys_to_sym(str_hash)
        str_hash.reduce({}) do |acc, (key, val)|
            acc[key.to_sym] = (['id', 'book_id'].include? key) ? val.to_i : val
            acc
        end
    end
end
