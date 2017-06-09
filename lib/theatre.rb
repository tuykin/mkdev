require 'time'

class Theatre < MovieCollection
  DAY_PERIODS = {
    morning: { time: 8...12, filters: { period: :ancient } },
    afternoon: { time: 12...17, filters: { genres: ['Comedy', 'Adventure'] } },
    evening: { time: 17...24, filters: { genres: ['Drama', 'Horror'] } }
  }

  def show(time_str)
    time = Time.parse(time_str)
    day_period = DAY_PERIODS.select { |_, v| v[:time].cover? time.hour }.values.first
    return nil if day_period.nil?

    movie = sample_magic_rand(filter(day_period[:filters]))
    puts "Now showing: #{movie.title}"
    movie
  end

  def when?(title)
    times = DAY_PERIODS.select do |_, attrs|
      filter(attrs[:filters].merge(title: title)).any?
    end.keys
    times << :never if times.empty?

    times
  end
end