class Movie
  class GenreNotFoundError < RuntimeError
  end

  attr_accessor :country, :date, :month, :year, :duration, :link, :producer, :rating, :title,
                :actors, :genres

  def initialize(collection, params)
    @collection = collection

    params.to_h.merge({
      year: params[:year].to_i,
      duration: params[:duration].to_i,
      rating: params[:rating].to_f,
      genres: params[:genres].split(','),
      actors: params[:actors].split(','),
      month: get_month(params[:date]),
      date: parse_date(params[:date])
    }).each { |k, v| send("#{k}=", v) }
  end

  def has_genre?(genre)
    raise GenreNotFoundError unless @collection.genres.include?(genre)
    genres.include?(genre)
  end

  def to_s
    "#{title} (#{country}; #{date}; #{genres.join('/')}) - #{duration} min"
  end

  def inspect
    "#{title} | #{country} | #{year} | #{producer} | #{genres} | #{actors} \n"
  end

  private

  def parse_date(str)
    (2 - str.count('-')).times { str << '-01' }
    Date.parse(str)
  end

  def get_month(str)
    str.split('-')[1]&.to_i || 0
  end
end