q = ARGV[0]&.downcase
file_name = ARGV[1] || 'movies.txt'

if !File.file?(file_name)
  puts "File '#{file_name}' not found"
  return
end

if q.nil?
  puts 'Enter query to search movie'
  return
end

found = false

File.foreach(file_name) do |line|
  movie_info = line.split('|')

  name = movie_info[1]
  rating = movie_info[7]
  stars_count = ((rating.to_f - 8) * 10).round
  stars = '*' * stars_count

  if name.downcase.include?(q)
    puts "#{name}: #{stars}"
    found = true
  end
end

puts 'no movie found' unless found