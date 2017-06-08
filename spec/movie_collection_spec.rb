require 'movie'
require 'movie_collection'
require 'ancient_movie'
require 'classic_movie'
require 'modern_movie'
require 'new_movie'

RSpec.describe MovieCollection do
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
      it { expect(subject.map(&:period)).to all(be :ancient) }
      it { expect(subject.map(&:class)).to all(be AncientMovie) }
      it { expect(subject.map(&:year).to_set).to be_subset (1900...1945).to_set }
    end

    context 'classic movies' do
      let(:period) { :classic }
      it { expect(subject.map(&:period)).to all(be :classic) }
      it { expect(subject.map(&:class)).to all(be ClassicMovie) }
      it { expect(subject.map(&:year).to_set).to be_subset (1945...1968).to_set }
    end

    context 'modern movies' do
      let(:period) { :modern }
      it { expect(subject.map(&:period)).to all(be :modern) }
      it { expect(subject.map(&:class)).to all(be ModernMovie) }
      it { expect(subject.map(&:year).to_set).to be_subset (1968...2000).to_set }
    end

    context 'new movies' do
      let(:period) { :new }
      it { expect(subject.map(&:period)).to all(be :new) }
      it { expect(subject.map(&:class)).to all(be NewMovie) }
      it { expect(subject.map(&:year).to_set).to be_subset (2000...Date.today.year).to_set }
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
end
