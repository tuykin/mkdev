require 'virtus'
require 'date'

module IMDB
  class Movie
    include Virtus.model

    GenreNotFoundError = Class.new(RuntimeError)

    class ArrayFromString < Virtus::Attribute
      def coerce(value)
        return value if value.is_a?(Array)
        return value.split(',') if value.is_a?(String)
      end
    end

    class FulfilledDate < Virtus::Attribute
      def coerce(value)
        return value if value.is_a?(Date)

        value = value.to_s
        (2 - value.count('-')).times { value << '-01' }
        Date.parse(value)
      end
    end

    attribute :country, String
    attribute :date, FulfilledDate
    attribute :month, Integer
    attribute :year, Integer
    attribute :duration, Integer
    attribute :link, String
    attribute :producer, String
    attribute :rating, Float
    attribute :title, String
    attribute :actors, ArrayFromString
    attribute :genres, ArrayFromString

    attr_reader :collection

    def initialize(collection = nil, params)
      @collection = collection
      super(params)
    end

    def self.build(collection = nil, params)
      params = prepare_data(params)
      case params[:year].to_i
      when 1900...1945
        IMDB::AncientMovie.new(collection, params)
      when 1945...1968
        IMDB::ClassicMovie.new(collection, params)
      when 1968...2000
        IMDB::ModernMovie.new(collection, params)
      when 2000..Date.today.year
        IMDB::NewMovie.new(collection, params)
      else
        IMDB::Movie.new(collection, params)
      end
    end

    def period
      self.class.name.split('::').last.gsub('Movie', '').downcase.to_sym
    end

    def has_genre?(genre)
      raise GenreNotFoundError if @collection && !@collection.genres.include?(genre)
      genres.include?(genre)
    end

    def fit?(key, value)
      field = send(key)

      if field.is_a?(Array)
        if value.is_a?(Array)
          (field & value).any?
        else
          field.any? { |i| value === i }
        end
      else
        value === field
      end
    end

    def to_s
      "#{title} (#{country}; #{date}; #{genres.join('/')}) - #{duration} min"
    end

    def inspect
      "#{title} | #{country} | #{year} | #{producer} | #{genres} | #{actors}"
    end

    private

    def self.prepare_data(params)
      params.to_h.merge({
        month: get_month(params[:date])
      })
    end

    def self.get_month(str)
      str.split('-')[1]&.to_i || 0
    end
  end
end
