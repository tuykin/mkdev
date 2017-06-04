require 'csv'
require 'date'

class MovieCollection
  class FileNotFoundError < RuntimeError
  end

  attr_accessor :genres

  KEYS = %i(link title year country date genres duration rating producer actors)

  def initialize(file_name)
    raise FileNotFoundError unless File.file?(file_name)
    @genres = []
    @movies = parse_file(file_name)
  end

  def all
    @movies
  end

  def sort_by(field)
    all.sort_by(&field)
  end

  def filter(facet)
    key = facet.keys.first
    value = facet.values.first

    return unless %i(genres country).include?(key)

    all.select { |m| m.send(key).include?(value) } || []
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

  def parse_file(file_name)
     CSV.foreach(file_name, col_sep: '|', headers: KEYS).map { |row| Movie.new(self, row) }
  end
end
