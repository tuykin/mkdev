require 'movie'
require 'movie_collection'
require 'ancient_movie'
require 'classic_movie'
require 'modern_movie'
require 'new_movie'

RSpec.describe MovieCollection do
  before(:each) do
    @movies = MovieCollection.new('movies.txt')
  end

  it '#initialize' do
    expect(@movies.all).to be_an(Array)
    expect(@movies.all.count).to eq(250)
  end

  it '#by_period' do
    expect(@movies.by_period().count).to eq(250)
    expect(@movies.by_period(:ancient).count).to eq(19)
    expect(@movies.by_period(:classic).count).to eq(56)
    expect(@movies.by_period(:modern).count).to eq(95)
    expect(@movies.by_period(:new).count).to eq(80)
  end

  describe '#filter' do
    it 'should return all' do
      expect(@movies.filter({})).to eq(@movies.all)
    end

    %i(ancient classic modern new).each do |period|
      it "should return #{period}" do
        expect(@movies.filter(period: period)).to match_array(@movies.by_period(period))
      end
    end

    it 'should return classic comedies' do
      expect(@movies.filter(genres: 'Comedy', period: :classic).count).to eq(6)
    end
  end
end