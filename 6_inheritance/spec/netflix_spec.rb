require 'netflix'
require 'movie'

RSpec.describe Netflix do
  it '#initialize' do
    netflix = Netflix.new('../movies.txt')
    expect(netflix.all.count).to eq(250)
  end

end