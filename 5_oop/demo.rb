load 'movie.rb'
load 'movie_collection.rb'

collection = MovieCollection.new('../movies.txt')
puts collection.all.first(5)#.map(&:inspect)