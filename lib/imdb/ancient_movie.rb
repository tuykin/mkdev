module IMDB
  require_relative 'movie'

  class AncientMovie < Movie
    def to_s
      "#{title} - старый фильм (#{year})"
    end
  end
end
