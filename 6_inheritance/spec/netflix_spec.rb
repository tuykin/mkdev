require 'netflix'
require 'movie'

RSpec.describe Netflix do
  it '#show' do
    netflix = Netflix.new
    movie = Movie.new(movie_params)
    expect(netflix.show(movie)).to eq("Now showing: #{movie.title}")
  end

  def movie_params
    {
      link: "http://imdb.com/title/tt0111161/?ref_=chttp_tt_1",
      title: "The Shawshank Redemption",
      year: "1994",
      country: "USA",
      date: "1994-10-14",
      genres: "Crime,Drama",
      duration: "142 min",
      rating: "9.3",
      producer: "Frank Darabont",
      actors: "Tim Robbins,Morgan Freeman,Bob Gunton"
    }
  end
end