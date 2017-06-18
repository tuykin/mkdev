require 'imdb/movie'
require 'imdb/ancient_movie'
require 'imdb/classic_movie'
require 'imdb/modern_movie'
require 'imdb/new_movie'
require 'imdb/movie_collection'

module IMDB
  describe Movie do
    describe '#initialize' do
      let(:movie) { described_class.new(movie_params) }
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
      let(:movie) { type.new(movie_params) }

      context 'AncientMovie' do
        let(:type) { AncientMovie }
        subject { movie.to_s }
        it { is_expected.to eq('The Shawshank Redemption - старый фильм (1994)') }
      end

      context 'ClassicMovie' do
        let(:type) { ClassicMovie }
        subject { movie.to_s }
        it { is_expected.to eq('The Shawshank Redemption - классический фильм, режиссёр Frank Darabont') }
      end

      context 'ModernMovie' do
        let(:type) { ModernMovie }
        subject { movie.to_s }
        it { is_expected.to eq('The Shawshank Redemption - современное кино: играют Tim Robbins, Morgan Freeman, Bob Gunton') }
      end

      context 'NewMovie' do
        let(:type) { NewMovie }
        let(:movie) { NewMovie.new(movie_params) }
        let(:years_ago) { Date.today.year - movie.year }
        subject { movie.to_s }
        it { is_expected.to eq("The Shawshank Redemption - новинка, вышло #{years_ago} лет назад!") }
      end

      context 'ClassicMovie with collection' do
        let(:movies) { MovieCollection.new('movies.txt') }
        let(:movie) { movies.filter(period: :classic, title: '12 Angry Men').first }
        subject { movie.to_s }
        it { is_expected.to eq('12 Angry Men - классический фильм, режиссёр Sidney Lumet (еще 3 его фильмов)') }
      end
    end

    describe '#fit?' do
      let(:movie) { described_class.new(movie_params)}

      context 'fit title by string' do
        let(:key) { :title }
        let(:value) { 'The Shawshank Redemption' }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'not fit title by string' do
        let(:key) { :title }
        let(:value) { 'The Shawshank' }
        subject { movie.fit?(key, value) }
        it { is_expected.to be false }
      end

      context 'fit title by regexp' do
        let(:key) { :title }
        let(:value) { /The Shawshank/i }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'fit year by interval' do
        let(:key) { :year }
        let(:value) { 1993...1995 }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'fit actors by string' do
        let(:key) { :actors }
        let(:value) { 'Morgan Freeman' }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'not fit actors by string' do
        let(:key) { :actors }
        let(:value) { 'Morgan' }
        subject { movie.fit?(key, value) }
        it { is_expected.to be false }
      end

      context 'fit actors by regexp' do
        let(:key) { :actors }
        let(:value) { /Morgan Freeman/i }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'fit genres by string' do
        let(:key) { :genres }
        let(:value) { 'Crime' }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'fit genres by array' do
        let(:key) { :genres }
        let(:value) { ['Crime', 'Comedy'] }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end

      context 'fit period' do
        let(:movie) { ClassicMovie.new(movie_params)}
        let(:key) { :period }
        let(:value) { :classic }
        subject { movie.fit?(key, value) }
        it { is_expected.to be true }
      end
    end

    let(:movie_params) do
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

    let(:movie_params_raw) do
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
end
