require 'time'

class Theatre < MovieCollection
  def show(time_str)
    time = Time.parse(time_str)
    movie = case time.hour
      when 8...12
        sample_magic_rand(filter(period: :ancient))
      when 12...17
        sample_magic_rand(filter(genres: ['Comedy', 'Adventure']))
      when 17...24
        sample_magic_rand(filter(genres: ['Drama', 'Horror']))
      else
        nil
      end
    puts "Now showing: #{movie.title}" unless movie.nil?
    movie
  end

  def when?(title)
    movies = filter({ title: title })
    times = []
    times << :morning if movies.map(&:period).include?(:ancient)

    times << :afternoon if movies.map(&:genres).include?('Comedy')
    times << :afternoon if movies.map(&:genres).include?('Adventure')

    times << :evening if movies.map(&:genres).include?('Drama')
    times << :evening if movies.map(&:genres).include?('Horror')

    times << :never if times.empty?

    times.uniq
  end
end