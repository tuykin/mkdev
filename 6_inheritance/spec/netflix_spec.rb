require 'netflix'

RSpec.describe Netflix do
  it '#show' do
    netflix = Netflix.new
    netflix.show()
  end
end