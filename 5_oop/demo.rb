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