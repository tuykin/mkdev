File.open('movies.txt', 'r') do |f|
  f.each_line do |line|
    movie_info = line.split('|')
    name = movie_info[1]
    rating = movie_info[7]
    stars_count = ((rating.to_f - 8) * 10).round
    stars = '*' * stars_count
    puts "#{name}: #{stars}"
  end
end
