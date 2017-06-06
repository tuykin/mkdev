class Netflix < MovieCollection
  def show(movie)
    "Now showing: #{movie.title}"
  end
end