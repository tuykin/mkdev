require 'movie'
require 'ancient_movie'
require 'classic_movie'
require 'modern_movie'
require 'new_movie'

RSpec.describe Movie do
  describe '#to_s' do
    it 'AncientMovie' do
      movie = AncientMovie.new(movie_params)
      expect(movie.to_s).to eq("#{movie.title} - старый фильм (#{movie.year})")
    end

    it 'ClassicMovie' do
      movie = ClassicMovie.new(movie_params)
      expect(movie.to_s).to eq("#{movie.title} — классический фильм, режиссёр #{movie.producer} ()")
    end

    it 'ModernMovie' do
      movie = ModernMovie.new(movie_params)
      expect(movie.to_s).to eq("#{movie.title} - современное кино: играют #{movie.actors}")
    end

    it 'NewMovie' do
      movie = NewMovie.new(movie_params)
      expect(movie.to_s).to eq("#{movie.title} - новинка, вышло #{Date.today.year - movie.year} лет назад!")
    end
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