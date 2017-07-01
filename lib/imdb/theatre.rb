require 'time'
require_relative 'cashbox'
require_relative 'movie_collection'

module IMDB
  class Theatre < MovieCollection
    include Cashbox

    HallIsNotDefined = Class.new(RuntimeError)

    class Period < OpenStruct
      def initialize(time, &block)
        super(from: time.first, to: time.last)
        instance_eval &block if block_given?
      end

      def description(value = nil)
        @description = value unless value.nil?
        @description
      end

      def filters(facets = {})
        @filters = facets unless facets.empty?
        @filters
      end

      def title(value = nil)
        @title = value unless value.nil?
        @title
      end

      def price(amount = nil)
        @price = amount unless amount.nil?
        @price
      end

      def hall(*halls)
        @halls = halls unless halls.empty?
      end

      def halls
        @halls ||= []
      end
    end

    attr_reader :halls, :periods

    DAY_PERIODS = {
      morning: { time: 8...12, price: 3, filters: { period: :ancient } },
      afternoon: { time: 12...17, price: 5, filters: { genres: %w[Comedy Adventure] } },
      evening: { time: 17...24, price: 10, filters: { genres: %w[Drama Horror] } }
    }.freeze

    def initialize(file_name, &block)
      @halls = {}
      super(file_name)
      build(&block) if block_given?
    end

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
      @periods ||= []

      period = Period.new(time, &block)
      check_halls!(period.halls)

      @periods << period
      period
    end

    private

    def choose_movie(day_period)
      sample_magic_rand(filter(day_period[:filters]))
    end

    def build(&block)
      instance_eval(&block) if block_given?
    end

    def check_halls!(halls)
      undefined_halls = halls - @halls.keys
      raise HallIsNotDefined, undefined_halls unless undefined_halls.empty?
    end
  end
end
