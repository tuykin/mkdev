require 'csv'
require 'date'

class MovieCollection
  class FileNotFoundError < RuntimeError
  end

  KEYS = %i(link title year country date genres duration rating producer actors)

  def initialize(file_name)
    raise FileNotFoundError unless File.file?(file_name)
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
    all.map { |m| m.send(field) }.flatten.each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
  end

  def print_stats(field)
    stats(field).sort.each do |field, count|
      puts "#{field}: #{count}"
    end
  end

  private

  def parse_file(file_name)
     CSV.foreach(file_name, col_sep: '|', headers: KEYS).map { |row| Movie.new(parse_row(row)) }
  end

  def parse_row(row)
    row.to_h.merge({
      year: row[:year].to_i,
      duration: row[:duration].to_i,
      rating: row[:rating].to_f,
      genres: row[:genres].split(','),
      actors: row[:actors].split(','),
      month: get_month(row[:date]),
      date: parse_date(row[:date])
    })
  end

  def parse_date(str)
    (2 - str.count('-')).times { str << '-01' }
    Date.parse(str)
  end

  def get_month(str)
    str.split('-')[1]&.to_i || 0
  end
end