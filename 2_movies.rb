q = ARGV[0].downcase

if q.nil?
  puts 'Enter query to search movie'
  return
end

found = false

File.open('movies.txt', 'r') do |f|
  f.each_line do |line|
    movie_info = line.split('|')

    name = movie_info[1]
    rating = movie_info[7]
    stars_count = ((rating.to_f - 8) * 10).round
    stars = '*' * stars_count

    if !name.downcase.index(q).nil?
      puts "#{name}: #{stars}"
      found = true
    end
  end
end

puts 'no movie found' unless found