require 'netflix'
require 'movie'

RSpec.describe Netflix do
  let(:netflix) { Netflix.new('movies.txt') }

  describe '#initialize' do
    subject { netflix }
    it { is_expected.to have_attributes(money: 0) }

    it { expect(netflix.all).to have_attributes(count: 250) }
  end

  describe '#pay' do
    it { expect { netflix.pay(10) }.to change { netflix.money }.from(0).to(10) }
  end

  # describe '#withdraw' do
  #   it 'should raise error' do
  #     expect { @netflix.withdraw(1) }.to raise_error(Netflix::NotEnoughMoney)
  #   end
  # end

  describe '#how_much?' do
    it { expect(netflix.how_much?('The Terminator')).to eq(Netflix::PRICE[:modern]) }
  end

  describe '#show' do
    subject { netflix.show(filter) }

    context 'no money' do
      let(:filter) { { period: :classic }}
      it { expect { subject }.to raise_error(Netflix::NotEnoughMoney) }
    end

    context 'with money' do
      before do
        allow(STDOUT).to receive(:puts)
        netflix.pay(amount)
      end
      let(:amount) { 10 }

      it { expect(netflix).to have_attributes(money: amount) }

      context 'no period' do
        let(:filter) { {} }
        it { expect { subject }.to raise_error(Netflix::NoPeriodSelected) }
      end

      context 'withdraw for ancient movie' do
        let(:filter) { {period: :ancient } }
        it { expect { subject }.to change { netflix.money }.from(10).to(9) }
      end

      context 'withdraw for classic movie' do
        let(:filter) { {period: :classic } }
        it { expect { subject }.to change { netflix.money }.from(10).to(8.5) }
      end

      context 'withdraw for modern movie' do
        let(:filter) { {period: :modern } }
        it { expect { subject }.to change { netflix.money }.from(10).to(7) }
      end

      context 'withdraw for new movie' do
        let(:filter) { {period: :new } }
        it { expect { subject }.to change { netflix.money }.from(10).to(5) }
      end

      context 'check output' do
        let(:filter) { { title: /Terminator/i, year: 1980..1990, period: :modern } }
        it { expect { subject }.to output("Now showing: The Terminator\n").to_stdout }
      end
    end
  end
end