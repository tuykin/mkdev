require 'time'

class Theatre < MovieCollection
  def show(time_str)
    time = Time.parse(time_str)
    movie = case time.hour
      when 8...12
        sample_magic_rand(morning_movies)
      when 12...17
        sample_magic_rand(afternoon_movies)
      when 17...24
        sample_magic_rand(evening_movies)
      else
        nil
      end
    puts "Now showing: #{movie.title}" unless movie.nil?
    movie
  end

  def when?(title)
    movies = filter({ title: title })
    times = []

    times << :morning if !morning_movies.select { |m| m.title == title }.empty?
    times << :afternoon if !afternoon_movies.select { |m| m.title == title }.empty?
    times << :evening if !evening_movies.select { |m| m.title == title }.empty?
    times << :never if times.empty?

    times
  end

  private

  def morning_movies
    filter(period: :ancient)
  end

  def afternoon_movies
    filter(genres: ['Comedy', 'Adventure'])
  end

  def evening_movies
    filter(genres: ['Drama', 'Horror'])
  end
end