module IMDB
  class NewMovie < Movie
    def to_s
      "#{title} - новинка, вышло #{Date.today.year - year} лет назад!"
    end
  end
end
