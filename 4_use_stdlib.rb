require 'csv'
require 'date'
require 'ostruct'

KEYS = %i(link title year country date genres duration rating producer starring)
MONTH_NAMES = %w(January February March April May June July August September October November December)
FILE_NAME = 'movies.txt'

if !File.file?(FILE_NAME)
  puts "File '#{FILE_NAME}' not found"
  return
end

def parse_date(str)
  (2 - str.count('-')).times { str << '-01' }
  Date.parse(str)
end

def build_movie(data)
  data = data.to_h

  OpenStruct.new(
    data.merge({
      year: data[:year].to_i,
      duration: data[:duration].to_i,
      rating: data[:rating].to_f,
      genres: data[:genres].split(','),
      starring: data[:starring].split(','),
      date: parse_date(data[:date])
    })
  )
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

movies = CSV
          .foreach(FILE_NAME, { col_sep: '|', headers: KEYS })
          .map { |movie_arr| build_movie(movie_arr) }

five_longest = movies.sort_by(&:duration).reverse!.take(5)
puts '*** 5 longest movies: ***'
print_movies(five_longest)
puts

ten_comedies = movies
                .select{ |m| m.genres.include?('Comedy') }
                .sort_by(&:date)
                .take(10)
puts '*** 10 comedies: ***'
print_movies(ten_comedies)
puts

producers = movies.map(&:producer).uniq
puts '*** producers ordered by surname: ***'
puts producers.sort_by { |m| m.split(' ').last }
puts

puts '*** foreign (not US) movies amount: ***'
puts movies.count { |m| m.country != 'USA' }
puts

puts '*** by month statistics: ***'
stats = movies
        .group_by { |m| m.date.month }
        .sort
        .map { |g| [get_month_name(g.first), g.last.count] }
        .to_h
stats.each do |month, count|
  puts "#{month}: #{count}"
end
puts "Total: #{stats.values.sum}"