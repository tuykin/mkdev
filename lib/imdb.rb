module IMDB
  libdir = File.dirname(__FILE__)
  $LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

  require_relative 'imdb/movie'
  require_relative 'imdb/movie_collection'
  require_relative 'imdb/ancient_movie'
  require_relative 'imdb/classic_movie'
  require_relative 'imdb/modern_movie'
  require_relative 'imdb/new_movie'
end
