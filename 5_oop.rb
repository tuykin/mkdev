libdir = [File.dirname(__FILE__), 'lib'].join('/')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'movie'
require 'movie_collection'

movies = MovieCollection.new('movies.txt')
puts '*** Sorting ***'
%i(link title year month date country genres duration rating producer actors).each do |field|
  puts movies.sort_by(field).first(5)
  puts
end

puts '*** Filtering ***'
[
  { genres: 'Comedy' }, { country: 'USA' }, { country: 'Russia' }, { title: /Terminator/i },
  { year: 2000 }, { producer: 'Robert Zemeckis' }, { actors: 'Morgan Freeman' }, { actors: /Morgan/i },
  { year: 2001..2008 }, { title: /Terminator/i, year: 1980..1990 }
].each do |facet|
  puts facet
  puts movies.filter(facet).first(5).inspect
  puts
end

puts '*** Stats ***'
%i(month year country producer actors genres).each do |field|
  puts movies.stats(field).inspect
  puts
end

movie = movies.all.first
puts movie.genres.inspect
puts movie.has_genre?('Crime')
puts movie.has_genre?('Comedy')

puts movies.genres.inspect
begin
  movie.has_genre?('Tragedy')
rescue Movie::GenreNotFoundError => e
  puts e
end