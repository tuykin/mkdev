require 'movie'
require 'ancient_movie'
require 'classic_movie'
require 'modern_movie'
require 'new_movie'

RSpec.describe Movie do
  describe '#initialize' do
    let(:movie) { Movie.new(movie_params) }
    subject { movie }
    it do
      is_expected.to have_attributes(
      title: movie_params[:title],
      year: movie_params[:year],
      actors: movie_params[:actors],
      )
    end
  end

  describe '#build' do
    let(:movie) { Movie.build(movie_params_raw.merge(year: year)) }
    subject { movie }

    context 'Movie' do
      let(:year) { '1899' }
      it { is_expected.to be_a(Movie).and have_attributes(year: 1899) }
    end

    context 'AncientMovie' do
      let(:year) { '1900' }
      it { is_expected.to be_a(AncientMovie).and have_attributes(year: 1900) }
    end

    context 'ClassicMovie' do
      let(:year) { '1945' }
      it { is_expected.to be_a(ClassicMovie).and have_attributes(year: 1945) }
    end

    context 'ModernMovie' do
      let(:year) { '1968' }
      it { is_expected.to be_a(ModernMovie).and have_attributes(year: 1968) }
    end

    context 'NewMovie' do
      let(:year) { '2000' }
      it { is_expected.to be_a(NewMovie).and have_attributes(year: 2000) }
    end
  end

  describe '#to_s' do
    context 'AncientMovie' do
      let(:movie) { AncientMovie.new(movie_params) }
      subject { movie.to_s }
      it { is_expected.to eq('The Shawshank Redemption - старый фильм (1994)') }
    end

    context 'ClassicMovie' do
      let(:movie) { ClassicMovie.new(movie_params) }
      subject { movie.to_s }
      it { is_expected.to eq('The Shawshank Redemption - классический фильм, режиссёр Frank Darabont ()') }
    end

    context 'ModernMovie' do
      let(:movie) { ModernMovie.new(movie_params) }
      subject { movie.to_s }
      it { is_expected.to eq('The Shawshank Redemption - современное кино: играют Tim Robbins, Morgan Freeman, Bob Gunton') }
    end

    context 'NewMovie' do
      let(:movie) { NewMovie.new(movie_params) }
      let(:years_ago) { Date.today.year - movie.year }
      subject { movie.to_s }
      it { is_expected.to eq("The Shawshank Redemption - новинка, вышло #{years_ago} лет назад!") }
    end
  end

  def movie_params
    {
      link: "http://imdb.com/title/tt0111161/?ref_=chttp_tt_1",
      title: "The Shawshank Redemption",
      year: 1994,
      country: "USA",
      date: 1994-10-14,
      genres: ['Crime', 'Drama'],
      duration: 142,
      rating: 9.3,
      producer: 'Frank Darabont',
      actors: ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton']
    }
  end

  def movie_params_raw
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