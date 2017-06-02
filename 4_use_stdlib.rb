require 'csv'
require 'date'
require 'ostruct'

KEYS = %i(link title year country date genres duration rating producer starring)
MONTH_NAMES = %w(January February March April May June July August September October November December)

# CSV::Converters[:array] = lambda do |s|
#   begin
#     raise ArgumentError unless s.include?(',')
#     s.split(',')
#   rescue ArgumentError
#     s
#   end
# end

def parse_date(str)
  str = str.to_s
  separators_count = str.count('-')
  (2 - separators_count).times { str << '-01' }
  Date.parse(str)
end

def build_movie(data)
  values = [
    data[0], data[1], data[2].to_i, data[3], parse_date(data[4]),
    data[5].split(','), data[6].to_i, data[7].to_f, data[8], data[9].split(',')
  ]
  OpenStruct.new(KEYS.zip(values).to_h)
end

def print_movie(movie)
  puts "#{movie.title} (#{movie.country}; #{movie.date}; #{movie.genres.join('/')}) - #{movie.duration} min"
end

def print_movies(movies)
  movies.each { |m| print_movie(m) }
end

def get_month_name(pos)
  MONTH_NAMES[pos - 1]
end

def print_stats(stats)
  stats.each do |month, count|
    puts build_line(month, count)
  end
  puts '-' * 15
  puts build_line('Total', stats.values.sum)
end

def build_line(header, count)
  str = ''
  str += ' ' * (10 - header.length)
  str += "#{header}: "
  str += ' ' * (3 - count.to_s.length)
  str += count.to_s
  str
end

file_name = 'movies.txt'

if !File.file?(file_name)
  puts "File '#{file_name}' not found"
  return
end

params = { col_sep: '|' }
movies = CSV.foreach(file_name, params).map { |movie_arr| build_movie(movie_arr) }

stats = movies
        .group_by { |m| m.date.month }
        .sort
        .map { |g| [get_month_name(g.first), g.last.count] }
        .to_h
print_stats(stats)