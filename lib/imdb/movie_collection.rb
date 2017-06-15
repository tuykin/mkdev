require 'csv'
require 'date'

require_relative 'movie'

module IMDB
  class MovieCollection
    class FileNotFoundError < RuntimeError
    end

    include Enumerable

    attr_reader :genres

    KEYS = %i(link title year country date genres duration rating producer actors)

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

    def sort_by(field)
      all.sort_by(&field)
    end

    def filter(facets = {})
      facets.reduce(all) do |res, (key, value)|
        res.select { |m| m.fit?(key, value) }
      end
    end

    def by_period(period = nil)
      return all if period.nil?

      all.select { |m| m.period == period }
    end

    def stats(field)
      return unless %i(month year country producer actors genres).include?(field)
      all.flat_map(&field).each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
    end

    def print_stats(field)
      stats(field).sort.each do |field, count|
        puts "#{field}: #{count}"
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
