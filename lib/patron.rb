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
      DB.exec("INSERT INTO checkouts (book_id, patron_id, due_date, checkout_date, status) VALUES (#{book['id'].to_i}, #{@id}, NOW() + '14 days', NOW(), 'true');")
    end
  end
  def delete
    DB.exec("DELETE FROM checkouts WHERE patron_id = #{@id};")
    DB.exec("DELETE FROM patrons WHERE id = #{@id};")
  end

  def books
    DB.exec("SELECT * FROM checkouts WHERE patron_id = #{@id};").map do |result|
      book_id = result["book_id"].to_i
      # due_date = result["due_date"]
      [Book.find(book_id), result['due_date'], result['checkout_date']]
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
    DB.exec("DELETE FROM patrons *;")
  end
  def self.find(search_id)
    attributes = DB.exec("SELECT * FROM patrons WHERE id = #{search_id};").first
    Patron.new(self.keys_to_sym(attributes))
  end

  private
  def self.keys_to_sym(str_hash)
    str_hash.reduce({}) do |acc, (key, val)|
      acc[key.to_sym] = (['id'].include? key) ? val.to_i : val
      acc
    end
  end
end
