class Movie
  class GenreNotFoundError < RuntimeError
  end

  @@genres = []

  attr_accessor :link, :title, :year, :month, :date, :country, :genres, :duration, :rating, :producer, :actors

  def initialize(params)
    params.each { |k, v| send("#{k}=", v) }
    @@genres |= genres
  end

  def has_genre?(genre)
    raise GenreNotFoundError unless @@genres.include?(genre)
    genres.include?(genre)
  end

  def to_s
    "#{title} (#{country}; #{date}; #{genres.join('/')}) - #{duration} min"
  end

  def self.genres
    @@genres
  end
end