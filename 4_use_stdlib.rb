require 'csv'
require 'date'

KEYS = %i(link title year country date genres duration rating producer starring)

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
  KEYS.zip(values).to_h
end

def print_movie(movie)
  puts "#{movie[:title]} (#{movie[:country]}; #{movie[:date]}; #{movie[:genres].join('/')}) - #{movie[:duration]} min"
end

def print_movies(movies)
  movies.each { |m| print_movie(m) }
end

file_name = 'movies.txt'

if !File.file?(file_name)
  puts "File '#{file_name}' not found"
  return
end

params = { col_sep: '|' }
movies = CSV.foreach(file_name, params).map { |movie_arr| build_movie(movie_arr) }
print_movies(movies)
