movie_name = ARGV[0]
GOOD_MOVIES = %w(Matrix)
BAD_MOVIES = %w(Titanic)

if GOOD_MOVIES.include?(movie_name)
  puts "#{movie_name} is a good movie"
elsif BAD_MOVIES.include?(movie_name)
  puts "#{movie_name} is a bad movie"
else
  puts "Haven't seen #{movie_name} yet"
end
