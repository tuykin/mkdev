class ClassicMovie < Movie
  def to_s
    if collection.nil? || another_movies.empty?
      "#{title} - классический фильм, режиссёр #{producer}"
    else
      another_movie_titles = another_movies.map(&:title).join(', ')
      "#{title} - классический фильм, режиссёр #{producer} (#{another_movie_titles})"
    end
  end

  private

  def another_movies
    collection.filter(producer: producer).take(10)
  end
end