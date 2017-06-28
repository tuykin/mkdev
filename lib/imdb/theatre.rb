require 'time'
require_relative 'cashbox'
require_relative 'movie_collection'

module IMDB
  class Theatre < MovieCollection
    HallIsNotDefined = Class.new(RuntimeError)

    include Cashbox

    attr_reader :halls

    def initialize(file_name, &block)
      @halls = {}
      super(file_name)
      instance_eval(&block) if block_given?
    end

    DAY_PERIODS = {
      morning: { time: 8...12, price: 3, filters: { period: :ancient } },
      afternoon: { time: 12...17, price: 5, filters: { genres: %w[Comedy Adventure] } },
      evening: { time: 17...24, price: 10, filters: { genres: %w[Drama Horror] } }
    }.freeze

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
        'No movie selected'
      else
        "You bought a ticket for #{movie.title}"
      end
    end

    def hall(key, params)
      @halls[key] = params
    end

    def period(time, &block)
      def description(name)
        obj.description = name
      end

      obj = OpenStruct.new
      obj.time = OpenStruct.new(from: time.first, to: time.last)

      yield if block_given?

      puts obj
      obj
    end

    private

    def choose_movie(day_period)
      sample_magic_rand(filter(day_period[:filters]))
    end
  end
end
