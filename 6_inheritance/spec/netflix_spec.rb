require 'netflix'
require 'movie'

RSpec.describe Netflix do
  before(:each) do
    @netflix = Netflix.new('../movies.txt')
  end

  it '#initialize' do
    expect(@netflix.all.count).to eq(250)
    expect(@netflix.money).to eq(0)
  end

  it '#pay' do
    @netflix.pay(1)
    expect(@netflix.money).to eq(1)
    expect(@netflix.pay(10)).to eq(@netflix.money)
  end

  describe '#withdraw' do
    it 'should raise error' do
      expect { @netflix.withdraw(1) }.to raise_error(Netflix::NotEnoughMoney)
    end
  end

  it '#how_much?' do
    expect(@netflix.how_much?('The Terminator')).to eq(Netflix::PRICE[:modern])
  end

  describe '#show' do
    before(:each) do
      @amount = 10
      @netflix.pay(@amount)
    end

    it 'should raise error' do
      expect { @netflix.show }.to raise_error(Netflix::NoPeriodSelected)
    end

    Netflix::PRICE.each do |period, price|
      it "should withdraw #{price} for #{period} movie" do
        expect { @netflix.show({ period: period }) }.to change { @netflix.money }
          .from(@amount)
          .to(@amount - price)
      end
    end

    it 'should return Movie#to_s' do
      filter = { title: /Terminator/i, year: 1980..1990, period: :modern }
      expect(@netflix.show(filter)).to eq('Now showing: The Terminator')
    end
  end
end