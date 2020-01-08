class Patron
    attr_accessor :name, :contact
    attr_reader :id
    def initialize(attributes)
        @name = attributes[:name]
        @contact = attributes[:contact]
        @id = attributes[:id]
    end
    def save
        @id = DB.exec("INSERT INTO patrons (name, contact) VALUES ('#{@name}', '#{@contact}') RETURNING id;").first.fetch("id").to_i
        self
    end
    def update(attributes)
        unless attributes[:name].nil? || attributes[:contact].nil?
            @name = attributes[:name]
            @contact = attributes[:contact]
            DB.exec("UPDATE patrons SET name = '#{@name}', contact = '#{@contact}' WHERE id = #{@id};")
        end
    end
    def add_book(book_title)
        book = DB.exec("SELECT * FROM books WHERE lower(title)='#{book_title.downcase}';").first
        unless book.nil?
            DB.exec("INSERT INTO checkouts (book_id, patron_id) VALUES (#{book['id'].to_i}, #{@id});")
        end
    end
    def delete
        DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id};")
        DB.exec("DELETE FROM artists WHERE id = #{@id};")
    end
    def books
        DB.exec("SELECT book_id FROM checkouts WHERE patron_id = #{@id};").map do |result|
            book_id = result["book_id"].to_i
            Book.find(book_id)
            # status = result["status"]
            # puts status
            # title = DB.exec("SELECT * FROM books WHERE id = #{book_id};").first['title']
            # Book.new({title: title, status: status, id: book_id})
        end
    end
    def ==(compare)
        (@name == compare.name) && (@contact == compare.contact) && (@id == compare.id)
    end

    #class methods
    def self.all
        DB.exec("SELECT * FROM patrons;").map { |patron| Patron.new(self.keys_to_sym(patron)) }
    end
    def self.clear
        DB.exec("DELETE FROM artists *;")
    end
    def self.find(search_id)
        attributes = DB.exec("SELECT * FROM artists WHERE id = #{search_id};").first
        Artist.new(self.keys_to_sym(attributes))
    end

    private
    def self.keys_to_sym(str_hash)
        str_hash.reduce({}) do |acc, (key, val)|
            acc[key.to_sym] = (['id'].include? key) ? val.to_i : val
            acc
        end
    end
end
