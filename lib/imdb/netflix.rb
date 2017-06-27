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

    PRICE = { ancient: 1, classic: 1.5, modern: 3, new: 5 }.freeze

    attr_reader :account, :filters, :by_genre

    def initialize(file_name)
      @account = Money.from_amount(0)
      @filters = {}
      super(file_name)
      @by_genre = init_by_genre_object
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

    def show(facets = {}, &block)
      movie = sample_magic_rand(filter(facets, &block))
      return puts "Movie not found" if movie.nil?

      withdraw(PRICE[movie.period])
      puts "Now showing: #{movie.title}"
      movie
    end

    def define_filter(filter_name, from: nil, arg: nil, &block)
      return @filters[filter_name] = block if from.nil?

      @filters[filter_name] = proc { |m| @filters[from].call(m, arg) }
    end

    def filter(facets = {}, &block)
      res = block_given? ? select { |m| yield(m) } : all

      custom_filters, movie_facets = facets.partition { |k, v| filters.keys.include?(k) }.map(&:to_h)

      res = custom_filters.reduce(res) do |res, (key, value)|
        filtering = proc { |m| filters[key].call(m, value) }
        res.select { |m| filtering.call(m) }
      end

      super(movie_facets, res)
    end

    private

    def withdraw(amount)
      amount = Money.from_amount(amount)
      raise NotEnoughMoney if @account < amount
      @account -= amount
    end

    def init_by_genre_object
      netflix = self
      obj = Object.new
      genres.each do |genre|
        obj.define_singleton_method symbolize_genre(genre) do
          netflix.filter(genres: genre)
        end
      end
      obj
    end

    def symbolize_genre(str)
      str.gsub('-','_').downcase
    end
  end
end
