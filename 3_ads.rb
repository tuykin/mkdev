require 'date'

def build_movie(line)
  data = line.split('|')
  keys = [:link, :title, :year, :country, :date, :genre, :duration, :rating, :producer, :starring]
  movie = {
    link: data[0],
    title: data[1],
    year: data[2].to_i,
    country: data[3],
    date: parse_date(data[4]),
    genres: data[5].split(','),
    duration: data[6].to_i,
    rating: data[7].to_f,
    producer: data[8],
    starrings: data[9].split(',')
  }

  movie
end

def parse_date(str)
  arr = str.split('-')
  arr << '01' if arr.size == 1
  arr << '01' if arr.size == 2
  new_str = arr.join('-')
  Date.parse(new_str)
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

movies = []

File.foreach(file_name) do |line|
  movies << build_movie(line)
end

five_longest = movies.sort_by { |m| -m[:duration] }.take(5)
puts '*** 5 longest movies: ***'
print_movies(five_longest)
puts

ten_comedies = movies
                .sort_by { |m| m[:date]}
                .select{ |m| m[:genres].include?('Comedy') }
                .take(10)
puts '*** 10 comedies: ***'
print_movies(ten_comedies)
puts

producers = movies.map { |m| m[:producer] }.uniq
puts '*** producers ordered by surname: ***'
puts producers.sort { |a, b| a.split(' ').last <=> b.split(' ').last}
puts

foreign_movies = movies.reject { |m| m[:country] == 'USA' }
puts '*** foreign (not US) movies amount: ***'
puts foreign_movies.size