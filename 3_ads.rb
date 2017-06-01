require 'date'

KEYS = %i(link title year country date genres duration rating producer starring)

def build_movie(line)
  data = line.split('|')
  values = [
    data[0], data[1], data[2].to_i, data[3], parse_date(data[4]),
    data[5].split(','), data[6].to_i, data[7].to_f, data[8], data[9].split(',')
  ]
  KEYS.zip(values).to_h
end

def parse_date(str)
  separators_count = str.count('-')
  (2 - separators_count).times { str << '-01' }
  Date.parse(str)
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

movies = File.foreach(file_name).map { |line| build_movie(line) }

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
puts producers.sort_by { |m| m.split(' ').last }
puts

puts '*** foreign (not US) movies amount: ***'
puts movies.count { |m| m[:country] != 'USA' }