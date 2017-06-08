require 'movie'
require 'movie_collection'
require 'ancient_movie'
require 'classic_movie'
require 'modern_movie'
require 'new_movie'

RSpec.describe MovieCollection do
  let(:movies) { MovieCollection.new('movies.txt') }

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
      it { is_expected.to have_attributes(count: 19) }
    end

    context 'classic movies' do
      let(:period) { :classic }
      it { is_expected.to have_attributes(count: 56) }
    end

    context 'modern movies' do
      let(:period) { :modern }
      it { is_expected.to have_attributes(count: 95) }
    end

    context 'new movies' do
      let(:period) { :new }
      it { is_expected.to have_attributes(count: 80) }
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
      it { is_expected.to match_array(movies.by_period(period)) }
    end

    context 'several filters' do
      let(:facets) { { genres: 'Comedy', period: :classic } }
      it { is_expected.to have_attributes(count: 6) }
    end
  end
end
