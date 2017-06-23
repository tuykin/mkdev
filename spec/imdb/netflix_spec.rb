require 'rspec/its'

require 'imdb/netflix'
require 'imdb/movie'

module IMDB
  describe Netflix do
    let(:netflix) { described_class.new('movies.txt') }

    describe 'class' do
      it { expect(described_class).to have_attributes(cash: 0) }
    end

    describe '#initialize' do
      subject { netflix }

      it { is_expected.to have_attributes(account: 0) }

      its(:count) { is_expected.to eq(250) }
    end

    describe '#pay' do
      let(:was) { Money.from_amount(0) }
      let(:become) { Money.from_amount(10) }
      it { expect { netflix.pay(10) }.to change(netflix, :account).from(was).to(become) }
    end

    describe '#how_much?' do
      subject { netflix.how_much?(title) }

      context 'for modern' do
        let(:title) { 'The Terminator' }
        let(:price) { Money.from_amount(described_class::PRICE[:modern]) }
        it { is_expected.to eq(price) }
      end

      context 'for absent movie' do
        let(:title) { 'blablabla' }
        it { expect { subject }.to raise_error(described_class::MovieNotFound) }
      end
    end

    describe '#show' do
      subject { netflix.show filter }

      context 'no money' do
        let(:filter) { { period: :classic } }
        it { expect { subject }.to raise_error(described_class::NotEnoughMoney) }
      end

      context 'with money' do
        before do
          allow(STDOUT).to receive(:puts)
          netflix.pay(amount)
        end
        let(:amount) { 10 }

        context 'withdraw for ancient movie' do
          let(:filter) { { period: :ancient } }
          let(:was) { Money.from_amount(10) }
          let(:become) { Money.from_amount(9) }
          it { expect { subject }.to change(netflix, :account).from(was).to(become) }
        end

        context 'withdraw for classic movie' do
          let(:filter) { { period: :classic } }
          let(:was) { Money.from_amount(10) }
          let(:become) { Money.from_amount(8.5) }
          it { expect { subject }.to change(netflix, :account).from(was).to(become) }
        end

        context 'withdraw for modern movie' do
          let(:filter) { { period: :modern } }
          let(:was) { Money.from_amount(10) }
          let(:become) { Money.from_amount(7) }
          it { expect { subject }.to change(netflix, :account).from(was).to(become) }
        end

        context 'withdraw for new movie' do
          let(:filter) { { period: :new } }
          let(:was) { Money.from_amount(10) }
          let(:become) { Money.from_amount(5) }
          it { expect { subject }.to change(netflix, :account).from(was).to(become) }
        end

        context 'check output' do
          let(:filter) { { title: /Terminator/i, year: 1980..1990, period: :modern } }
          it { expect { subject }.to output("Now showing: The Terminator\n").to_stdout }
        end

        context 'with block' do
          subject { netflix.show(&filter) }
          let(:was) { Money.from_amount(10) }
          let(:become) { Money.from_amount(7) }
          let(:filter) do
            lambda { |movie| movie.title.include?('Terminator') && movie.genres.include?('Action') && movie.year > 1990 }
          end
          it { expect { subject }.to output("Now showing: Terminator 2: Judgment Day\n").to_stdout
                                 .and change(netflix, :account).from(was).to(become) }
        end
      end
    end

    describe '#account' do
      context 'one for all' do
        let(:another_netflix) { described_class.new('movies.txt') }

        before do
          described_class.send(:reset_cashbox)
          netflix.pay(5)
          another_netflix.pay(10)
        end

        it { expect(netflix.account).to eq(Money.from_amount(5)) }
        it { expect(another_netflix.account).to eq(Money.from_amount(10)) }
        it { expect(described_class.cash).to eq(Money.from_amount(15)) }
      end
    end

    describe '#define_filter' do
      before do
        allow(STDOUT).to receive(:puts)
        netflix.define_filter(filter_name, &filter)
        netflix.pay(10)
      end

      subject { netflix.show(defined_filter) }

      context 'simple' do
        let(:filter_name) { :terminator }
        let(:defined_filter) { { filter_name => true } }
        let(:filter) do
          lambda { |movie| movie.title.include?('Terminator') && movie.genres.include?('Action') && movie.year > 1990 }
        end

        it { expect(netflix.filters.keys).to eq([filter_name]) }
        it { expect { subject }.to output("Now showing: Terminator 2: Judgment Day\n").to_stdout }
      end

      context 'with block param' do
        let(:filter_name) { :new_sci_fi }
        let(:filter) { lambda { |year, movie| movie.genres.include?('Sci-Fi') && movie.year == year} }
        let(:defined_filter) { { filter_name => 2010 } }

        it { is_expected.to have_attributes(genres: include('Sci-Fi'), year: 2010) }
      end

      context 'specified filter' do
        before do
          netflix.define_filter(:new_sci_fi, &filter)
          netflix.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
        end

        let(:filter_name) { :new_sci_fi }
        let(:defined_filter) { { filter_name => true } }
        let(:filter) { lambda { |year, movie| movie.genres.include?('Sci-Fi') && movie.year == year} }

        it { expect(netflix.filters.keys).to match_array([:new_sci_fi, :newest_sci_fi]) }

        it { expect(netflix.show(newest_sci_fi: true))
              .to have_attributes(genres: include('Sci-Fi'), year: 2014) }
      end
    end
  end
end
