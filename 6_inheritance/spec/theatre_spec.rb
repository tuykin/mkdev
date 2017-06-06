require 'theatre'

RSpec.describe Theatre do
  it '#show' do
    theatre = Theatre.new
    theatre.show()
  end
end