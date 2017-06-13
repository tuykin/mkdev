require 'time'
require_relative 'cashbox'
require_relative 'movie_collection'

class Theatre < MovieCollection
  include ::Cashbox

  def initialize(file_name, money = 0)
    reset_cashbox(money)
    super(file_name)
  end

  DAY_PERIODS = {
    morning: { time: 8...12, price: 3, filters: { period: :ancient } },
    afternoon: { time: 12...17, price: 5, filters: { genres: ['Comedy', 'Adventure'] } },
    evening: { time: 17...24, price: 10, filters: { genres: ['Drama', 'Horror'] } }
  }

  def show(time_str)
    time = Time.parse(time_str)
    day_period = DAY_PERIODS.select { |_, v| v[:time].cover? time.hour }.values.first
    return nil if day_period.nil?

    movie = choose_movie(day_period)
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

  def buy_ticket(day_period)
    fill(DAY_PERIODS[day_period][:price])
    movie = choose_movie(DAY_PERIODS[day_period])
    if movie.nil?
      "No movie selected"
    else
      "You bought a ticket for #{movie.title}"
    end
  end

  private

  def choose_movie(day_period)
    sample_magic_rand(filter(day_period[:filters]))
  end
end
