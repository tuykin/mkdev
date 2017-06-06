require 'movie'
require 'movie_collection'
require 'ancient_movie'
require 'classic_movie'
require 'modern_movie'
require 'new_movie'

RSpec.describe MovieCollection do
  it '#initialize' do
    movies = MovieCollection.new('../movies.txt')
    expect(movies.all.count).to eq(250)
    expect(movies.all.select { |m| m.class == AncientMovie }.count).to eq(19)
    expect(movies.all.select { |m| m.class == ClassicMovie }.count).to eq(56)
    expect(movies.all.select { |m| m.class == ModernMovie }.count).to eq(95)
    expect(movies.all.select { |m| m.class == NewMovie }.count).to eq(80)
  end
end