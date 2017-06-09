class ClassicMovie < Movie
  def to_s
    if collection.nil? || another_movies.empty?
      "#{title} - классический фильм, режиссёр #{producer}"
    else
      "#{title} - классический фильм, режиссёр #{producer} (еще #{another_movies.count} его фильмов)"
    end
  end

  private

  def another_movies
    collection.filter(producer: producer)
  end
end