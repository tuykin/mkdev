require 'imdb/movie_collection'
require 'imdb/cashbox'

require 'imdb/ancient_movie'
require 'imdb/classic_movie'
require 'imdb/modern_movie'
require 'imdb/new_movie'

module IMDB
  class Netflix < MovieCollection
    class MovieNotFound < RuntimeError; end

    include Cashbox
    extend Cashbox

    PRICE = { ancient: 1, classic: 1.5, modern: 3, new: 5 }

    reset_cashbox

    def initialize(file_name)
      reset_cashbox
      super(file_name)
    end

    def pay(amount)
      fill(amount)
      self.class.fill(amount)
    end

    def money
      cash
    end

    def how_much?(title)
      movie = filter(title: title).first
      raise MovieNotFound if movie.nil?
      PRICE[movie.period]
    end

    def show(period:, **facets)
      withdraw(PRICE[period])
      movie = sample_magic_rand(filter(facets.merge(period: period)))
      puts "Now showing: #{movie.title}"
      movie
    end
  end
end
