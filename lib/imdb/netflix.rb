require_relative 'movie_collection'
require_relative 'cashbox'

require_relative 'ancient_movie'
require_relative 'classic_movie'
require_relative 'modern_movie'
require_relative 'new_movie'

module IMDB
  class Netflix < MovieCollection
    MovieNotFound = Class.new(RuntimeError)
    NotEnoughMoney = Class.new(RuntimeError)

    extend Cashbox

    PRICE = { ancient: 1, classic: 1.5, modern: 3, new: 5 }

    attr_reader :account

    def initialize(file_name)
      @account = Money.from_amount(0)
      super(file_name)
    end

    def pay(amount)
      @account += Money.from_amount(amount)
      self.class.fill(amount)
    end

    def how_much?(title)
      movie = filter(title: title).first
      raise MovieNotFound if movie.nil?
      Money.from_amount(PRICE[movie.period])
    end

    def show(period:, **facets)
      withdraw(PRICE[period])
      movie = sample_magic_rand(filter(facets.merge(period: period)))
      puts "Now showing: #{movie.title}"
      movie
    end

    private

    def withdraw(amount)
      amount = Money.from_amount(amount)
      raise NotEnoughMoney if @account < amount
      @account -= amount
    end
  end
end
