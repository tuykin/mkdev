require 'csv'
require 'date'

require_relative 'movie'
require_relative 'ancient_movie'
require_relative 'classic_movie'
require_relative 'modern_movie'
require_relative 'new_movie'

module IMDB
  class MovieCollection
    FileNotFoundError = Class.new(RuntimeError)

    include Enumerable

    attr_reader :genres

    KEYS = %i[link title year country date genres duration rating producer actors].freeze

    def initialize(file_name)
      raise FileNotFoundError unless File.file?(file_name)
      @movies = parse_file(file_name)
      @genres = @movies.flat_map(&:genres).uniq
    end

    def each(&block)
      @movies.each(&block)
    end

    def all
      @movies
    end

    def filter(facets = {}, &block)
      return select { |m| block.call(m) } if block_given?

      facets.reduce(all) do |res, (key, value)|
        res.select { |m| m.fit?(key, value) }
      end
    end

    def by_period(period = nil)
      return all if period.nil?

      select { |m| m.period == period }
    end

    def stats(field)
      return unless %i[month year country producer actors genres].include?(field)
      flat_map(&field).each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
    end

    def print_stats(field)
      stats(field).sort.each do |field_name, count|
        puts "#{field_name}: #{count}"
      end
    end

    private

    def sort_magic_rand(movies)
      movies.sort_by { |m| m.rating * rand }
    end

    def sample_magic_rand(movies)
      sort_magic_rand(movies).first
    end

    def parse_file(file_name)
      CSV.foreach(file_name, col_sep: '|', headers: KEYS).map { |row| Movie.build(self, row) }
    end
  end
end
