class Movie
  attr_accessor :link, :title, :year, :month, :date, :country, :genres, :duration, :rating, :producer, :actors

  def initialize(params)
    params.each { |k, v| send("#{k}=", v) }
  end

  def has_genre?(genre)

  end

  def to_s
    "#{title} (#{country}; #{date}; #{genres.join('/')}) - #{duration} min"
  end
end