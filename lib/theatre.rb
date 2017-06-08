require 'time'

class Theatre < MovieCollection
  def show(time_str)
    time = Time.parse(time_str)
    movie = case time.hour
      when 8...12
        filter(period: :ancient).sample
      when 12...17
        filter(genres: ['Comedy', 'Adventure']).sample
      when 17...24
        filter(genres: ['Drama', 'Horror']).sample
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