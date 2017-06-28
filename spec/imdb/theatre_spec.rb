require 'imdb/theatre'
require 'imdb/movie'

module IMDB
  describe Theatre do
    let(:theatre) { described_class.new('movies.txt') }

    describe '#initialize' do
      subject { theatre }

      its(:count) { is_expected.to eq(250) }
    end

    describe '#show' do
      before { allow(STDOUT).to receive(:puts) }
      subject { theatre.show(time) }

      context 'morning' do
        let(:time) { '8:00' }
        its(:period) { is_expected.to eq(:ancient) }
      end

      context 'afternoon' do
        let(:time) { '12:00' }
        its(:genres) { is_expected.to include('Comedy').or(include('Adventure')) }
      end

      context 'evening' do
        let(:time) { '18:00' }
        its(:genres) { is_expected.to include('Horror').or(include('Drama')) }
      end

      context 'night' do
        let(:time) { '3:00' }
        it { is_expected.to be_nil}
      end
    end

    describe '#when?' do
      subject { theatre.when?(title) }

      context 'never' do
        let(:title) { 'The Terminator' }
        it { is_expected.to match_array([:never]) }
      end

      context 'morning' do
        let(:title) { 'M' }
        it { is_expected.to match_array([:morning, :evening]) }
      end

      context 'afternoon' do
        let(:title) { 'X-Men: Days of Future Past' }
        it { is_expected.to match_array([:afternoon]) }
      end

      context 'evening' do
        let(:title) { 'The Silence of the Lambs' }
        it { is_expected.to match_array([:evening]) }
      end
    end

    describe '#cash' do
      subject { theatre.cash }

      context 'no cash' do
        it { is_expected.to eq(0) }
      end

      context 'separate for each instance' do
        before do
          theatre.buy_ticket(:morning)
          another_theatre.buy_ticket(:evening)
        end

        let(:another_theatre) { described_class.new('movies.txt') }

        it { is_expected.to eq(Money.from_amount(3)) }
        it { expect(another_theatre.cash).to eq(Money.from_amount(10)) }
      end
    end

    describe '#buy_ticket' do
      subject { theatre.buy_ticket(day_period) }

      context 'morning' do
        let(:day_period) { :morning }
        let(:was) { Money.from_amount(0) }
        let(:become) { Money.from_amount(3) }
        it { expect { subject }.to change(theatre, :cash).from(was).to(become) }
              # .and_return('You bought ticket to ...') }
      end

      context 'afternoon' do
        let(:day_period) { :afternoon }
        let(:was) { Money.from_amount(0) }
        let(:become) { Money.from_amount(5) }
        it { expect { subject }.to change(theatre, :cash).from(was).to(become) }
      end

      context 'evening' do
        let(:day_period) { :evening }
        let(:was) { Money.from_amount(0) }
        let(:become) { Money.from_amount(10) }
        it { expect { subject }.to change(theatre, :cash).from(was).to(become) }
      end
    end

    describe '#take' do
      before { theatre.buy_ticket(:evening) }
      subject { theatre.take(who) }

      context 'Bank' do
        let(:who) { 'Bank' }
        let(:was) { Money.from_amount(10) }
        let(:become) { Money.from_amount(0) }
        it { expect { subject }.to change(theatre, :cash).from(was).to(become).and output("Проведена инкассация\n").to_stdout }
      end

      context 'someone else' do
        let(:who) { 'someone else' }
        it { expect { subject }.to raise_error(Cashbox::Unauthorized).and output("Полиция уже едет\n").to_stdout }
      end
    end

    describe '#new' do
      subject { described_class.new('movies.txt', &definition) }

      context 'hall definition' do
        let(:definition) { proc { hall :red, title: 'Красный зал', places: 100 } }

        it { is_expected.to have_attributes(halls: { red: { title: 'Красный зал', places: 100 } }) }
      end

      context 'period definition' do
        let(:definition) do
          proc do
            halls

            period '09:00'..'11:00' do
              description 'Утренний сеанс'
              filters genre: 'Comedy', year: 1900..1980
              price 10
              hall :red, :blue
            end
          end
        end

        context 'raises no hall error' do
          let(:halls) { proc { hall :red, title: 'Красный зал', places: 100 } }

          xit { expect { subject }.to raise_error(IMDB::Theatre::HallIsNotDefined) }
        end

        context 'ok' do
          let(:halls) do
            proc do
              hall :red, title: 'Красный зал', places: 100
              hall :blue, title: 'Синий зал', places: 50
            end
          end

          xit { expect(subject.halls[:red][:periods].first.description).to eq('Утренний сеанс')}
        end
      end
    end

    describe '#period' do
      # period '09:00'..'11:00' do
      #         description 'Утренний сеанс'
      #         filters genre: 'Comedy', year: 1900..1980
      #         price 10
      #         hall :red, :blue
      #       end
      subject { theatre.period(time, &block) }

      context 'time definition' do
        let(:time) { '09:00'..'11:00' }
        let(:block) { nil }

        its(:time) { is_expected.to have_attributes(from: '09:00', to: '11:00') }
      end

      context 'with description' do
        let(:time) { '09:00'..'11:00' }
        let(:block) { proc { description 'Утренний сеанс' } }

        its(:description) { is_expected.to eq('Утренний сеанс') }
      end
    end
  end
end
