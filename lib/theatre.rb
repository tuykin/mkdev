require 'time'

class Theatre < MovieCollection
  DAY_PERIODS = { morning: 8...12, afternoon: 12...17, evening: 17...24 }

  def show(time_str)
    time = Time.parse(time_str)
    day_period = DAY_PERIODS.select { |_, v| v.cover? time.hour }.keys.first
    return nil if day_period.nil?

    movie = sample_magic_rand(send("#{day_period}_movies"))
    puts "Now showing: #{movie.title}"
    movie
  end

  def when?(title)
    times = DAY_PERIODS.select do |day_period, time_period|
      !send("#{day_period}_movies").select { |m| m.title == title }.empty?
    end.keys
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