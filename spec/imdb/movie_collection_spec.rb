require 'imdb/movie'
require 'imdb/movie_collection'
require 'imdb/ancient_movie'
require 'imdb/classic_movie'
require 'imdb/modern_movie'
require 'imdb/new_movie'

module IMDB
  describe MovieCollection do
    let(:movies) { described_class.new('movies.txt') }

    describe '#all' do
      subject { movies.all }
      it { is_expected.to be_an(Array).and have_attributes(count: 250) }
    end

    describe '#by_period' do
      subject { movies.by_period(period) }

      context 'with empty period' do
        let(:period) { nil }
        it { is_expected.to have_attributes(count: 250) }
      end

      context 'ancient movies' do
        let(:period) { :ancient }
        it {
          is_expected
            .to all be_an(AncientMovie)
            .and have_attributes(period: :ancient, year: match(1900...1945))
        }
      end

      context 'classic movies' do
        let(:period) { :classic }
        it {
          is_expected
            .to all be_an(ClassicMovie)
            .and have_attributes(period: :classic, year: match(1945...1968))
        }
      end

      context 'modern movies' do
        let(:period) { :modern }
        it {
          is_expected
            .to all be_an(ModernMovie)
            .and have_attributes(period: :modern, year: match(1968...2000))
        }
      end

      context 'new movies' do
        let(:period) { :new }
        it {
          is_expected
            .to all be_an(NewMovie)
            .and have_attributes(period: :new, year: match(2000...Date.today.year))
        }
      end
    end

    describe '#filter' do
      subject { movies.filter(facets) }

      context 'empty facet' do
        let(:facets) { {} }
        it { is_expected.to eq(movies.all) }
      end

      context 'by period' do
        let(:period) { :ancient }
        let(:facets) { { period: period } }
        it { expect(subject.map(&:period)).to all(be period) }
      end

      context 'several filters' do
        let(:facets) { { genres: 'Comedy', period: :classic } }
        it { expect(subject.map(&:period)).to all(be :classic) }
        it { expect(subject.map(&:genres)).to all(include('Comedy')) }
      end

      context 'several genres' do
        let(:facets) { { genres: ['Comedy', 'Adventure'] } }
        it { expect(subject.map(&:genres)).to all(include('Comedy').or include('Adventure')) }
      end

      context 'several genres' do
        let(:facets) { { genres: ['Drama', 'Horror'] } }
        it { expect(subject.map(&:genres)).to all(include('Drama').or include('Horror')) }
      end
    end

    describe 'Enumerable mixin' do
      subject { movies }
      it { is_expected.to respond_to :each }
      it { is_expected.to respond_to :map }
      it { is_expected.to respond_to :select }
      it { is_expected.to respond_to :reject }

      describe '#map' do
        subject { movies.map(&:period).uniq }
        it { is_expected.to match_array([:ancient, :classic, :modern, :new]) }
      end

      describe '#select' do
        subject { movies.select { |m| m.title == 'The Terminator' } }
        it { is_expected.to have_attributes(count: 1) }
        it { expect(subject.first.title).to eq('The Terminator') }
      end
    end
  end
end
