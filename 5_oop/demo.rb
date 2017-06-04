load 'movie.rb'
load 'movie_collection.rb'

movies = MovieCollection.new('../movies.txt')
puts '*** Sorting ***'
%i(link title year month date country genres duration rating producer actors).each do |field|
  puts movies.sort_by(field).first(5)
  puts
end

puts '*** Filtering ***'
[{ genres: 'Comedy' }, { country: 'USA' }, { country: 'Russia' }].each do |facet|
  puts movies.filter(facet).first(5)
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

puts Movie.genres.inspect
begin
  movie.has_genre?('Tragedy')
rescue Movie::GenreNotFoundError => e
  puts e
end